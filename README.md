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

## Klasör yapısı

```text
apps/mobile/              Flutter uygulaması
  lib/app/                Başlangıç, yönlendirme, tema
  lib/core/               Ortak ayarlar ve hata yönetimi
  lib/shared/widgets/     Ortak arayüz bileşenleri
  lib/features/           auth, home, events, news, favorites, chat vb.
    <özellik>/presentation/  Ekran ve ekran durumu
    <özellik>/data/          Veri erişimi
apps/backend/             Dart servisleri, kaynak adaptörleri ve işler
  lib/src/integrations/    Spor/haber kaynaklarına bağlantılar
  lib/src/modules/         Ortak veri dönüşümü, kaynak seçimi ve iş kuralları
  lib/src/jobs/            Veri yenileme, bildirim ve temizlik
packages/domain_models/   Mobil/backend ortak Dart modelleri
contracts/                Veri sözleşmeleri ve örnekler
firebase/                 Erişim kuralları ve indeksler
infra/                    Cloud Run, Scheduler ve yetki ayarları
.github/workflows/        Otomatik kontroller
```

Bu, hedef yapıdır; şimdilik ana klasör iskeleti hazır. Flutter/Dart projeleri, alt klasörler ve otomatik kontroller henüz oluşturulmadı. UI/UX görselleri incelendikten sonra önce örnek verili ekranlar ve tıklamalar, ardından gerçek veri bağlantıları geliştirilecek.

## Çalışma dalları

**`main`** ortak ve onaylanmış sürüm, **`seyyid`** Seyyid'in, **`kenan`** Kenan'ın çalışma dalıdır. Hazır işler incelendikten sonra `main`e birleştirilir; iki geliştirici de güncel `main`i kendi dalına alır.
