# Futbolix

Canlı skor, fikstür, puan durumu, spor haberleri, favoriler ve maç sohbeti sunacak Android uygulaması.

## Sistem mimarisi

| Bileşen | Görevi |
|---|---|
| **Flutter / Dart** | Mobil ekranlar, sayfa geçişleri ve kullanıcı etkileşimleri |
| **Dart backend / Cloud Run** | Dış verileri ortak biçime dönüştürme, sohbet kuralları ve bildirim işlemleri |
| **Firebase Authentication** | Kullanıcı girişi ve hesap yönetimi |
| **Cloud Firestore** | Maç verileri, haber kartları, favoriler ve sohbet mesajları |
| **Firebase Cloud Messaging** | Gol, maç başlangıcı ve bitişi gibi olayların bildirimleri |
| **Cloud Scheduler** | Skor/haber yenileme ve temizlik işlerini zamanlama |

```text
Spor ve haber kaynakları → Dart backend → Firestore → Flutter
                                  └→ FCM → Telefona bildirim
Flutter → Firebase Auth → Kullanıcı girişi
Flutter → Dart backend → Sohbet ve yetkili işlemler
```

- Dış kaynakları backend ortak olarak sorgular; her kullanıcı için ayrı istek gönderilmez.
- Firestore'a yalnız değişen maç verileri yazılır. Haberlerde gerekli ve kullanımına izin verilen kart bilgileri saklanır.
- Kaynak bağlantıları ayrı adaptörlerde tutulur; veri kaynağı değiştiğinde ekranları yeniden yazmak gerekmez. API/haber kaynağı seçimi ayrıca netleştirilecek.
- Sohbet gerçek maç durumuyla açılır; maç bitince yazmaya kapanır. Mesajlar 24 saat okunabilir, ardından kullanıcı erişimi kapanır ve normal mesajlar temizlenir. Şikâyet kayıtları ayrı tutulur.
- Sohbet maliyeti ayrı izlenir; bulut kurulumunda bütçe uyarıları açılır. API anahtarları mobil uygulamaya veya GitHub'a konmaz.

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
packages/domain_models/   Mobil/backend ortak Dart modelleri
contracts/                Veri sözleşmeleri ve örnekler
firebase/                 Erişim kuralları ve indeksler
infra/                    Cloud Run, Scheduler ve yetki ayarları
.github/workflows/        Otomatik kontroller
```

Bu, hedef yapıdır; şimdilik ana klasör iskeleti hazır. Flutter/Dart projeleri, alt klasörler ve otomatik kontroller henüz oluşturulmadı. UI/UX görselleri incelendikten sonra önce örnek verili ekranlar ve tıklamalar, ardından gerçek veri bağlantıları geliştirilecek.

## Çalışma dalları

**`main`** ortak ve onaylanmış sürüm, **`seyyid`** Seyyid'in, **`kenan`** Kenan'ın çalışma dalıdır. Hazır işler incelendikten sonra `main`e birleştirilir; iki geliştirici de güncel `main`i kendi dalına alır.
