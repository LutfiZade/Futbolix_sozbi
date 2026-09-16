# Futbolix

Flutter Android uygulaması + Dart backend + Firebase. İki kişilik geliştirme için tek repo.

**Durum:** Klasör ve çalışma düzeni hazırlığı. Henüz çalıştırılabilir Flutter/Dart uygulaması yok. UI/UX görselleri incelendikten sonra önce örnek verili ekranlar ve tıklamalar geliştirilecek.

**Veri bütçesi:** Ücretli API aboneliği planlanmıyor. ESPN ve diğer ücretsiz kaynaklar için erişim, kapsam ve ticari kullanım doğrulaması gerekli. ESPN üretim kaynağı olarak kesinleşmedi. Ücretsiz veri, ücretsiz bulut işletimi garantisi değildir.

## Başlangıç belgeleri

- [Ana mimari ve T01–T42 görevleri](docs/FUTBOLIX-PROJE-PLANI.md)
- [Ücretsiz veri ve GitHub hazırlığı](docs/FUTBOLIX-UCRETSIZ-VERI-VE-GITHUB-HAZIRLIK.md)
- [Önceki API/RSS araştırması ve fiyat karşılaştırması](docs/FUTBOLIX-API-HIZ-VE-KAYNAK-KARSILASTIRMASI.md)
- [İki kişi için Git çalışma düzeni](CONTRIBUTING.md)
- [Veri kaynaklarının ortak sözleşmesi](contracts/sports-provider.md)

## Dosyalama

```text
apps/
  mobile/                 Flutter: ekranlar, router, tema, özellikler
  backend/                Dart: kullanıcı API'si, veri işleri, adaptörler
packages/domain_models/   Ortak saf Dart modelleri
contracts/                Veri örnekleri, kaynak yetenekleri, API sözleşmeleri
firebase/                 Rules, indeksler, emulator ayarları
infra/                    Cloud Run, Scheduler, IAM, bütçe ayarları
docs/                     Güncel plan ve kaynak araştırması
.github/                  Görev ve PR şablonları; gelecekte CI
```

Alt klasörlerdeki README'ler sorumlulukları anlatır; uygulama kodu yerine geçmez. Ortak model üzerinden örnek veri/gerçek kaynak değiştirilecek; ekranlar ESPN veya başka bir sağlayıcıya doğrudan bağlanmayacak.

## Çalışma

Repoda üç kalıcı dal kullanılır:

| Dal | Kullanım |
|---|---|
| `main` | Ortak klasör yapısı ve incelenip birleştirilmiş güncel uygulama |
| `seyyid` | Seyyid'in geliştirmeleri |
| `kenan` | Kenan'ın geliştirmeleri |

Herkes kendi dalında çalışır. Hazır değişiklikler `seyyid → main` veya `kenan → main` pull request'iyle birleştirilir; diğer geliştirici inceler. Birleştirmeden sonra ikiniz de `main` güncellemelerini kendi dalınıza alırsınız. Bu üç dal silinmez; PR'larda merge commit yöntemi kullanılır. Ayrıntılar [birlikte çalışma belgesinde](CONTRIBUTING.md).

Notion görevinize ilgili issue/PR bağlantısını ekleyin. Proje üretildikten sonra Flutter/Dart sürümleri sabitlenecek ve gerçek analiz/test/derleme kontrolleri kurulacak. Şu an CI veya branch koruması aktif varsayılmamalı.

Müşteri sözleşmeleri, gerçek kullanıcı verileri, API anahtarları ve servis hesabı dosyaları bu repoya eklenmez.
