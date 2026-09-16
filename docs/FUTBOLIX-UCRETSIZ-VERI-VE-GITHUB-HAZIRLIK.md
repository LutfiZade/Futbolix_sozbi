# Futbolix — Ücretsiz Veri ve GitHub Hazırlığı

**Kontrol:** 16 Eylül 2026. **Karar:** Spor/haber API'sine ücret ödemeden geliştirmeye başlanacak; üretim verisinin kapsamı ve izni ayrıca doğrulanacak. UI/UX görselleri gelmeden uygulama ekranları yazılmayacak.

## Mimari değişiyor mu?

**Flutter + Dart backend + Cloud Run + Firebase Auth/Firestore/FCM omurgası korunuyor.** Yeni veritabanı, farklı programlama dili veya ayrı mikroservis gerekmiyor. Spor kaynağını değiştirilebilir bir katman olarak tutacağız:

```text
Geliştirme: örnek veri → ortak modeller → Flutter ekranları
Üretim: doğrulanmış ücretsiz kaynak → SportsProvider → Dart → Firestore → Flutter
Haber: izinli RSS/Atom veya uygun ücretsiz API → NewsProvider → aynı veri akışı
Yeni maç olayı → kalıcı bildirim işi → FCM
```

Asıl değişiklik, sağlayıcıya güvenerek bütün özellikleri hazır kabul edemememizdir. Kaynak bazında spor/lig listesi, canlı durum, puan tablosu, kadro, olay ve logo desteği tutulur. Her özellik için erişim, güncellik ve kullanım hakkı doğrulanır. Hiçbir mobil ekran ESPN adresine doğrudan bağlanmaz.

## ESPN kontrolünün sonucu

Bu ortamda aşağıdaki iki açık adres denendi:

- [Süper Lig skor uç noktası](https://site.api.espn.com/apis/site/v2/sports/soccer/tur.1/scoreboard): **HTTP 403 / Access Denied**.
- [NBA skor uç noktası](https://site.api.espn.com/apis/site/v2/sports/basketball/nba/scoreboard): **HTTP 403 / Access Denied**.

Bu sonuç ESPN'nin herkese kapalı veya verisinin her ortamda erişilemez olduğunu kanıtlamaz. Ancak testten başarılı veri alınmadı; kapsam veya hız doğrulanmış sayılmaz. Eski geliştirici merkezinin [overview adresi](https://www.espn.com/apis/devcenter/overview.html) 404 döndü. ESPN ana sayfasının bağladığı [kullanım koşulları](https://disneytermsofuse.com/turkish/) da bu ortamda 403 verdi; bu incelemede ticari yeniden kullanım hakkı doğrulanamadı.

**ESPN şu an araştırma adayıdır; tek ve garantili üretim kaynağı değildir.** İnternette örnek JSON adreslerinin bulunması, ücretsiz ticari API sözleşmesi veya hizmet sürekliliği taahhüdü anlamına gelmez. Erişim engelini aşmak için proxy/kimlik gizleme yöntemi kurulmayacak. Yetkili kullanım ve normal erişim doğrulanırsa Dart adaptörü eklenebilir.

## Diğer ücretsiz seçenekler

| Kaynak | Ücretsiz olarak doğrulanan | Futbolix açısından sınır |
|---|---|---|
| football-data.org | 12 futbol organizasyonu; gecikmeli skor/fikstür, puan durumu; 10 istek/dakika | Ücretsiz listede Süper Lig yok. Basketbol/voleybol çözümü değil. Hızlı gol bildirimi ve maçla eşzamanlı chat açılışı için yeterli olduğu kabul edilemez. |
| Highlightly Basic | Günlük 100 istek; ücretsiz deneme imkânı | 100 dakika boyunca dakikada bir tek sorgu bile bütün günlük kotayı tüketir; detaylar ve diğer sporlar ayrıca istek ister. |
| TheSportsDB Free | Geliştirmede veri/görsel API'si | Güncel şartları mağazada yayımlanan uygulama için ücretli abonelik istiyor. Canlı skorlar premium kapsamda. Sıfır abonelikli Play sürümüne çözüm olarak seçilmedi. |
| İzinli RSS/Atom | Ücretsiz erişilen Türkçe spor haber akışları mevcut | Mobil yayın ve görsel izinleri ayrıca doğrulanır; açık akış serbest yeniden yayın garantisi değildir. |

Kaynaklar: [football-data fiyat](https://www.football-data.org/pricing), [ücretsiz lig kapsamı](https://www.football-data.org/coverage), [Highlightly paketleri](https://highlightly.net/sport-api/), [TheSportsDB ücretsiz API](https://www.thesportsdb.com/free_sports_api), [TheSportsDB şartları](https://www.thesportsdb.com/docs_terms_of_use.php), [NTV Spor RSS](https://www.ntvspor.net/rss), [NTV Spor kullanım şartları](https://www.ntvspor.net/kullanim-kosullari).

**Sonuç:** Ücretsiz geliştirme/prototip mümkün. Maçkolik kapsamındaki bütün sporlar ve ligler için ücretsiz, sürekli ve ticari yayına uygun canlı veri çözümü henüz doğrulanmadı. Bu açığı uygulama mimarisi tek başına kapatamaz. Tam kapsamı sessizce azaltmayacağız; eksik lig/özellikleri müşteri kararı için görünür tutacağız.

## Kaynak değişimine karşı küçük önlemler

- `SportsProvider` ve `NewsProvider` ortak arayüzleri; örnek veri ile gerçek kaynak aynı modelleri üretir.
- Uygulamanın maç kimliği sabit, sağlayıcı kimlikleri ayrı. Kaynak değişince favori/sohbet kaydı kaybolmaz.
- Aynı maç için tek yetkili skor kaynağı; eşleme ve doğrulama olmadan otomatik kaynak karıştırma yapılmaz.
- Kaynak/lig başına açma-kapama, kota ve desteklenen özellik ayarı. Ücretli kaynağa otomatik geçiş yok.
- 403/429/kesinti halinde sınırlı tekrar, eski veri etiketi ve bildirim durdurma. Eski skor yeni gol gibi gönderilmez.
- Chat saat 18.00 olduğu için açılmaz; doğrulanmış güncel maç durumuna bağlıdır. Gecikmeli veya eksik kaynak bu deneyimi etkiler.
- API abonelik bedeli 0 hedeflenir; Cloud Run/Firestore/ağ/log giderleri ayrıca izlenir. İlk bulut kurulumunda bütçe uyarıları kurulur; sohbet tüketimi ayrı ölçülür.

## GitHub kontrolü

Repo: [LutfiZade/Futbolix_sozbi](https://github.com/LutfiZade/Futbolix_sozbi).

- İlk erişimde bağlantı aracı 404 verdi; yerel Git okuması çalıştı. Kullanıcının ayar değişikliği sonrasında repo `public` olarak doğrulandı.
- Varsayılan dal `main`; ilk incelemedeki başlangıç commit'i `4d5cb12` yalnız `README.md` içeriyordu.
- Yerel çalışma kopyası `Futbolix_sozbi/` altında. Ortak klasör ve belgeler `main`de tutulur.
- Kullanıcının kararıyla yalnız üç kalıcı dal kullanılır: `main`, `seyyid`, `kenan`. Kişisel dallar aynı ortak başlangıçtan açılır; geçici hazırlık dalı bu düzene dahil değildir.
- Hazırlık yalnız klasör/doküman/çalışma düzenidir. Flutter/Dart uygulaması üretilmedi; UI ekranı, Firebase projesi veya ücretli servis oluşturulmadı.

## İki kişi için çalışma düzeni

1. İkiniz aynı repoyu kendi bilgisayarınıza klonlayın; aynı yerel klasörü paylaşmayın.
2. Küçük bir Notion görevi seçin; GitHub issue/branch/PR bağlantısını o göreve ekleyin. Tek başlık altında kimin sorumlu olduğu belli olsun.
3. Seyyid `seyyid`, Kenan `kenan` dalında çalışır; her görev için ek dal açılmaz. Normal geliştirmede `main`e doğrudan push yapmayın.
4. Ortak model değişikliği varsa önce veri sözleşmesini birlikte netleştirin; biri ekranı örnek veriyle, diğeri veri bağlantısını bağımsız geliştirebilir.
5. Kendi dalınızdan `main`e pull request açın; diğer kişi kontrol etsin. Kontroller geçince merge commit ile birleştirin. Kişisel dalı silmeyin; ikiniz de güncel `main`i kendi dalınıza merge edin.
6. Branch koruması ve zorunlu CI, repo yöneticisi tarafından ilk çalışan Flutter/Dart kontrolü kurulduğunda etkinleştirilsin. Şu an yapılandırıldı sayılmıyor.

Sözleşme PDF'si, müşteri ticari belgeleri, API anahtarları ve servis hesabı dosyaları repoya eklenmez. Repo herkese açık olduğundan kaynak kodu paylaşım yetkisi de proje sahibi tarafından korunmalıdır; bu hazırlıkta gizlilik ayarı değiştirilmedi.

## UI/UX geldikten sonraki ilk adımlar

- [ ] Görselleri ekranlara ve tıklanabilir akışlara ayır.
- [ ] Flutter/Dart sürümünü sabitle; Android uygulama kimliğini belirle ve gerçek proje iskeletini oluştur.
- [ ] Tema, ortak kartlar ve menü geçişlerini örnek verilerle çalıştır.
- [ ] Aynı sırada ücretsiz kaynakların izin/kapsam/erişim kontrolünü tamamla.
- [ ] En az bir doğrulanmış gerçek veri örneğini ortak modele bağla; kaynak bağımlılığını mobil ekrana taşıma.
- [ ] API erişimi netleşmeden tüm liglerin canlı olduğunu veya gol/chat hızının karşılandığını kabul etme.
