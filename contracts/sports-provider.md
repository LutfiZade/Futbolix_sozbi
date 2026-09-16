# Spor ve haber kaynaklarının ortak sözleşmesi

Bu belge başlangıç sözleşmesidir; çalışan adaptör veya gerçek API şeması değildir.

## SportsProvider

- Spor/lig/sezon ve desteklenen özellikleri bildirir.
- Maç listesi, detay, skor/olay, fikstür ve sıralamayı ortak modellere dönüştürür; olmayan özellik için desteklenmiyor sonucu verir.
- Her kayıtta iç kimlik, kaynak kimliği, sağlayıcı maç kimliği ve alınma zamanı bulunur. Kaynak güncelleme/olay zamanı yalnız sağlayıcı gerçekten veriyorsa eklenir.
- Canlı, gecikmeli, eski, desteklenmiyor ve hata durumları birbirinden ayrılır.
- Aynı sorgu kullanıcı başına tekrarlanmaz. Sayfalama, kota ve hata yönetimi backend'dedir.
- Maç durumu bilinmiyorsa takvim saatinden canlı durum uydurulmaz. Eski olaydan push üretilmez.
- Kaynak değişimi sırasında kimlik eşlemesi ve kayıt sırası doğrulanır; bir maç için iki kaynağın skorları otomatik birleştirilmez.

## NewsProvider

RSS/Atom veya uygun API; aynı NewsArticle modeli. İzinli başlık/özet, kaynak adı, orijinal bağlantı, zamanlar ve varsa izinli görsel tutulur. Haber kartından orijinal sayfa açılır. Kaynak izni, saklama süresi ve tekrar önleme zorunludur.

## Örnek veri

Geliştirmede elle hazırlanmış örnek kayıtlar kullanılacak. Gerçek maçmış gibi etiketlenmez; üretimde örnek veri modu etkinleştirilmez. Ücretsiz kaynak kontrolü arayüz çalışmalarıyla birlikte yapılır.

`providers.example.json` planlama örneğidir; uygulama tarafından henüz okunmaz ve hiçbir dış kaynağı otomatik etkinleştirmez.
