# Flutter mobil

UI/UX görsellerinden sonra Android projesi burada oluşturulacak. İlk adım örnek verili ekranlar ve tıklanabilir geçişlerdir.

```text
lib/
  app/                 bootstrap, router, theme
  core/                config, errors, time
  shared/widgets/      gerçekten ortak bileşenler
  features/
    auth/ home/ sports/ competitions/ events/
    participants/ favorites/ news/ notifications/
    chat/ moderation/ settings/
      presentation/    ekran ve controller
      data/            repository ve veri bağlantısı
```

`presentation/data` ayrımı gereken her özelliğe uygulanır. Repository arayüzü önce örnek veriye, sonra Firebase/backend'e bağlanır. Mobil uygulama dış spor/haber kaynağına veya gizli anahtara erişmez.
