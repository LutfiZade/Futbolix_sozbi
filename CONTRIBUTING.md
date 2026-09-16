# Birlikte çalışma

## Üç dal, iki geliştirici

- `main`: Ortak klasör yapısı ve incelenmiş, birleştirilmiş kod.
- `seyyid`: Seyyid kendi değişikliklerini burada yapar.
- `kenan`: Kenan kendi değişikliklerini burada yapar.

Her görev için yeni dal açılmayacak. Küçük görevler aynı kişisel dalda sırayla tamamlanacak; biten işler PR ile `main`e alınacak.

1. Notion'dan tek bir görev seçin; sorumlusunu ve kabul ölçütünü yazın.
2. Kendi dalınıza geçin; önce o dalın uzaktaki halini, sonra güncel `main`i alın. Kaydedilmemiş değişiklik varsa önce commit edin.
3. Ortak veri modeli değişecekse diğer geliştiriciyle önce sözleşmeyi netleştirin. Sağlayıcı alanlarını ekran koduna taşımayın.
4. Küçük, anlaşılır commit'ler hazırlayın; ilgisiz dosyaları eklemeyin.
5. Kendi dalınızı gönderip `seyyid → main` veya `kenan → main` PR'ı açın. Notion görevini bağlayın; ne değiştiğini ve nasıl kontrol edildiğini yazın.
6. Diğer geliştirici incelesin. Gerekli kontroller geçince **Create a merge commit** ile `main`e birleştirin. Kişisel dalı silmeyin; squash/rebase merge yerine ortak geçmişi koruyan merge commit kullanın.
7. İkiniz de güncel `main`i kendi dalınıza merge edin. Çakışma varsa çözün ve değişen akışı kontrol edin. `main` yalnız boş bir iskelet olarak kalmaz; onaylanan geliştirmeler burada birikir.

Normal geliştirmede `main`e doğrudan push veya force push kullanılmaz. Branch koruması ve zorunlu kontroller repo yöneticisince kurulacak; bu dosyanın bulunması GitHub ayarlarını etkinleştirmez. Her geliştiricinin kendi bilgisayarında kendi klonu olmalıdır.

## Günlük Git komutları

Seyyid için, temiz çalışma alanında:

```bash
git switch seyyid
git pull --ff-only origin seyyid
git fetch origin
git merge origin/main
# Görevi tamamla, kontrol et ve ilgili dosyaları commit et.
git push origin seyyid
```

Kenan aynı komutlarda `seyyid` yerine `kenan` kullanır. Merge çakışırsa çözülmeden sonraki adıma geçilmez. PR birleştirildikten sonra `git fetch origin` ve `git merge origin/main` tekrar uygulanır; böylece diğer kişinin işi de kişisel dala gelir.

## Görev ne zaman biter?

- UI görevi: tasarıma uygun görünür ve belirtilen tıklamalar örnek verilerle çalışır.
- Kaynak araştırması: erişim/kapsam/izin kanıtı ve karar kaydedilir.
- Entegrasyon görevi: gerçek veriyle çalışır; hata ve izin kontrolleri doğrulanır.

Örnek verili ekranı gerçek entegrasyon tamamlanmış gibi işaretlemeyin. Notion ve GitHub'da iki ayrı uzun görev listesi yönetmek yerine Notion görevinden branch/issue/PR'a bağlantı verin.

## İlk kurulumdan sonra kontroller

Flutter/Dart sürümü UI başlangıcında sabitlenecek. Ardından değişikliğe uygun format, analiz, test ve Android derleme kontrolleri kurulacak. Henüz proje olmadığı için çalıştırılmış veya başarılı CI iddiası yoktur.

## Repoya girmeyecekler

Sözleşme/müşteri ticari belgeleri, gerçek kullanıcı verileri, tokenlar, `.env`, servis hesabı JSON'ları ve imzalama anahtarları. `.gitignore` yardımcıdır; commit öncesi eklenen dosyaları yine kontrol edin. Gerçek servis sırları üretimde Secret Manager'da tutulur.

Veri aboneliği 0 hedeflenir. Kaynak erişimi kesilirse ücretsiz kotayı/erişim kontrolünü aşmayın veya izinsiz ücretli pakete geçmeyin; sorunu ve kapsam etkisini kaydedin.
