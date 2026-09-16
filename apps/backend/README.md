# Dart backend

Tek kod tabanı: kullanıcı işlemleri ve yetkili veri işleri. Planlanan iki Cloud Run dağıtımı aynı kodu farklı erişim sınırlarıyla çalıştırır.

```text
bin/server.dart
lib/src/
  http/                  routes, auth, app_check, validation
  modules/               sports, news, chat, moderation, users
  integrations/
    sports/              SportsProvider, yalnız doğrulanmış adaptörler
    news/                NewsProvider, RSS/Atom veya seçilen API
    firebase/
  jobs/                  sync, dispatch, cleanup
  repositories/
test/
Dockerfile
```

Bu dosyalar henüz üretilmedi. ESPN entegrasyonu doğrulanmış değil. Sağlayıcı istekleri kullanıcı başına yapılmaz; değişmeyen skor tekrar yazılmaz. Chat/bildirim için yalnız güncel, doğrulanmış maç durumu kullanılır.
