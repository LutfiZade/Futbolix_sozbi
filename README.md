# Futbolix

Canlı skor, fikstür, puan durumu, spor haberleri, favoriler ve maç sohbeti sunacak Android uygulaması.

## Sistem mimarisi

| Bileşen | Görevi |
|---|---|
| **Flutter / Dart** | Mobil ekranlar, sayfa geçişleri ve kullanıcı etkileşimleri |
| **Dart backend / Cloud Run** | Spor/lig bazında kaynak seçimi, ortak veri modelleri, sohbet kuralları ve bildirim işlemleri |
| **Firebase Authentication** | Kullanıcı girişi ve hesap yönetimi |
| **Cloud Firestore** | Maç verileri, haber kartları, favoriler ve sohbet mesajları |
| **Firebase Cloud Messaging** | Gol, maç başlangıcı ve bitişi gibi olayların bildirimleri |
| **Cloud Scheduler** | Dakika ve üzeri aralıklarda veri yenileme ve temizlik işlerini zamanlama |

```text
Spor/lig için ana veya yedek kaynak ─┐
Haber için izinli ücretsiz kaynak ──┴→ Dart backend
                                      (adaptörler + ortak modeller)
                                                ↓
                                           Firestore → Flutter
Yeni maç olayı → Kalıcı bildirim işi → FCM → Telefona bildirim
Flutter → Firebase Auth → Kullanıcı girişi
Flutter → Dart backend → Sohbet ve yetkili işlemler
```

- Dış kaynakları backend ortak olarak sorgular; her kullanıcı için ayrı istek gönderilmez.
- Firestore'a yalnız değişen maç verileri yazılır. Haberlerde gerekli ve kullanımına izin verilen kart bilgileri saklanır.
- Kaynak bağlantıları ayrı adaptörlerde tutulur; sağlayıcı değiştiğinde mobil ekranları yeniden yazmak gerekmez. Kaynak seçimi backend'dedir.
- Sohbet gerçek maç durumuyla açılır; maç bitince yazmaya kapanır. Mesajlar 24 saat okunabilir, ardından kullanıcı erişimi kapanır ve normal mesajlar temizlenir. Şikâyet kayıtları ayrı tutulur.
- Sohbet maliyeti ayrı izlenir; bulut kurulumunda bütçe uyarıları açılır. API anahtarları mobil uygulamaya veya GitHub'a konmaz.

## Ücretsiz veri ve hız yaklaşımı

**Hedefimiz spor ve haber API abonelik bedelini 0 tutmak.** Her spor/lig için kapsam, ticari kullanım izni, kota ve güncellik doğrulanacak. Tüm sporların ücretsiz ve hızlı veriyle karşılanabildiği henüz kanıtlanmış değil; ücretsiz API, ücretsiz bulut işletimi anlamına gelmez.

1. Her spor/lig için uygun bir **ana kaynak**, varsa doğrulanmış bir **yedek kaynak** seçilir. Haberlerde izinli RSS/Atom veya uygun ücretsiz haber servisi kullanılır. Hiçbir sağlayıcı henüz üretim için kesinleşmedi.
2. Ana kaynak hata verdiğinde veya verisinin eski olduğu doğrulandığında yedek değerlendirilir. İki kaynağı sürekli sırayla sorgulamak varsayılan yöntem değildir; hız avantajı ve gerçek bağımsızlığı ölçülmeden kullanılmaz.
3. Aynı maçın kaynak kimlikleri tek uygulama kimliğine eşlenir. Eski cevaplar ve yinelenen olaylar ayıklanır; VAR/skor düzeltmeleri işlenir. Kaynak değişimi ikinci bir gol bildirimi veya sohbet odası oluşturmaz.
4. Maç öncesi fikstür, saat ve iptal bilgileri seyrek kontrol edilir. Canlı maçlarda, kaynak ve kota uygunsa **15–30 saniyelik sorgulama denenir**; bu, golün kullanıcıya bu sürede ulaşacağı garantisi değildir. Maç sonrasında sınırlı düzeltme kontrolü yapılır.
5. Kaynak destekliyorsa birden fazla maç tek sorguda alınır. Haberler ayrı ve daha seyrek yenilenir. Kesintide son veri güncellik bilgisiyle gösterilir; eski veriden yeni bildirim üretilmez. Güncel maç durumu bilinmiyorsa sohbet yazımı duraklatılır.

Dakika altı sorgulama için Cloud Scheduler tek başına yeterli değildir; Cloud Run'da uygun çalışan bir işleyici veya sağlayıcının desteklediği canlı akış gerekir. Bu çalışma biçimi ve bulut maliyeti gerçek maç testinden sonra belirlenir. Ücretli kaynağa otomatik geçilmez.

## Flutter ve Dart klasör yapısı

```text
apps/
  mobile/                           Flutter Android uygulaması
    pubspec.yaml                    Mobil bağımlılıkları ve varlık tanımları
    android/                        Android Studio, Gradle ve yerel Android dosyaları
    assets/images, icons, fonts/    Görsel, ikon ve yazı tipi klasörleri
    lib/
      main.dart                     Mobil giriş noktası
      app/
        bootstrap.dart              Uygulamayı başlatma
        futbolix_app.dart           MaterialApp ve uygulama kabuğu
        router/                     Ekran geçişleri
        theme/                      Tema
      core/                         config, errors, time, telemetry
      shared/widgets/               Gerçekten ortak arayüz bileşenleri
      features/
        home/presentation/          Başlangıç ekranı
        <özellik>/presentation/     Ekran, widget ve controller/viewmodel
        <özellik>/data/             Repository ve veri bağlantısı
    test/                           Birim ve widget testleri
    integration_test/               Uygulama akışı testleri
  backend/                          Saf Dart sunucu uygulaması
    pubspec.yaml                    Backend bağımlılıkları
    bin/server.dart                 Sunucu giriş noktası
    lib/src/
      http/                         İstekler; ileride kimlik ve erişim doğrulama
      modules/                      sports, news, chat, moderation, users
      integrations/
        sports/                     Spor kaynağı adaptörleri
        news/                       RSS/Atom ve haber servisi adaptörleri
        firebase/                   Sunucunun Firebase bağlantıları
      repositories/                 Veri okuma/yazma
      jobs/                         Güncelleme, bildirim ve temizlik
    test/                           Backend testleri
packages/domain_models/
  pubspec.yaml                      Ortak saf Dart paketi
  lib/domain_models.dart            Paylaşılan modellerin dışa açılan girişi
  lib/src/                          Ortak modellerin tanımları
  test/                             Model testleri
contracts/                          Veri sözleşmeleri ve örnekler
firebase/                           Erişim kuralları ve indeksler
infra/                              Cloud Run, Scheduler ve yetki ayarları
.github/workflows/                  Otomatik kontroller
```

Mobil özellik klasörleri: `auth`, `home`, `sports`, `competitions`, `events`, `participants`, `favorites`, `news`, `notifications`, `chat`, `moderation`, `settings`. Her birinde `presentation` ve `data` ayrımı bulunur.

**Dosyayı nereye koyacağız?** Mobil ekranlar ve durum yönetimi `presentation`, verinin nereden alındığı `data` içindedir. Dış spor/haber servisleriyle yalnız backend'in `integrations` bölümü konuşur. Sunucu iş kuralları `modules`, tekrarlanan işler `jobs` içindedir. İki uygulamanın gerçekten paylaştığı modeller `domain_models` paketinde tutulur; bu paket Flutter'a veya Firebase'e bağımlı olmaz. Mobil ile backend birbirinin kaynak kodunu içe aktarmaz.

Flutter uygulama kodunun kökü `lib/`, backend'in iç kodlarının yeri `lib/src/` olarak seçildi. Ortak paketin dışarı açacağı modeller `domain_models.dart` üzerinden sunulacak. Her projenin kendi `pubspec.yaml` dosyası vardır; mobil ve backend ortak pakete yerel `path` bağımlılığıyla bağlanır.

## Şu an hazır olanlar

Android destekli Flutter başlangıcı, Dart sunucu başlangıcı ve ortak Dart paketi oluşturuldu. Mobilde yalnız geçici **Futbolix** ekranı, backend'de yalnız `GET /healthz` kontrolü bulunur. Boş klasörlerdeki `.gitkeep`, klasörün GitHub'da görünmesini sağlar; özelliğin tamamlandığı anlamına gelmez.

UI/UX ekranları, yönlendirme, Firebase/API bağlantıları, iş kuralları, test senaryoları, Docker/Cloud Run kurulumu ve otomatik kontroller sonraki işlerdir. Varlık klasörleri hazırdır; gerçek görsel/fontlar geldiğinde `pubspec.yaml` içinde tanımlanacak. API anahtarı veya bulut hesabı bu başlangıca bağlanmadı.

UI/UX'i beklemeden ortak iskeleti hazırlayabiliriz. Görseller geldiğinde önce örnek verili ekranlar ve tıklamalar, ardından gerçek veri bağlantıları geliştirilecek.

## Yerelde açma ve çalıştırma

Başlangıç **Flutter 3.41.4 / Dart 3.11.1** ile oluşturuldu. Android Studio'da Flutter/Dart desteğiyle `apps/mobile` klasörünü açın; emülatörü Device Manager'dan seçin. `android/` klasörü yalnız yerel Android/Gradle işlemleri içindir.

Mobil için `apps/mobile` terminalinde:

```sh
flutter pub get
flutter run
```

Backend için `apps/backend` terminalinde:

```sh
dart pub get
dart run bin/server.dart
```

Backend yerelde `http://127.0.0.1:8080/healthz` adresinde çalışır; `HOST` ve `PORT` ortam değişkenleriyle ayarlanabilir. İki uygulama bu aşamada birbirine bağlı değildir. Android uygulama kimliği şimdilik `com.example.futbolix_mobile` yer tutucusudur; Firebase/Google Play kurulumundan önce müşteri adına ait kalıcı kimlik ve yayın imzası belirlenecek.

## Çalışma dalları

**`main`** ortak ve onaylanmış sürüm, **`seyyid`** Seyyid'in, **`kenan`** Kenan'ın çalışma dalıdır. Hazır işler incelendikten sonra `main`e birleştirilir; iki geliştirici de güncel `main`i kendi dalına alır.
