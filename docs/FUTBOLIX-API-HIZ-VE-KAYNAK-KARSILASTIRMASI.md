# Futbolix — Skor API'si, RSS/Haber Kaynakları, Hız ve Mimari

**Araştırma tarihi:** 16 Eylül 2026
**Ana plan:** [Futbolix proje planı](FUTBOLIX-PROJE-PLANI.md)
**Yeni karar:** API abonelik bütçesi 0 olarak hedefleniyor. Bu belgedeki ücretli paketler karşılaştırma referansıdır; aktif seçim veya satın alma onayı değildir. [Güncel ücretsiz veri ve GitHub değerlendirmesi](FUTBOLIX-UCRETSIZ-VERI-VE-GITHUB-HAZIRLIK.md) ve ana plan v4.3 önce okunmalıdır.
**Durum:** Resmî ürün, fiyat ve dokümantasyon incelemesi. Ücretli abonelik alınmadı; API anahtarıyla canlı maç testi yapılmadı. Aşağıdaki süreler sağlayıcı beyanı veya açıkça belirtilmiş tasarım hedefidir; ölçülmüş Futbolix performansı değildir.

## 1. Önceki ücretli/ücretsiz karşılaştırmanın sonucu

**Flutter + Dart backend + Firebase omurgası uygun. Ancak API seçimi mimarinin önemli bir girdisi: saniyelik skor istiyorsak veri toplama ve çalıştırma biçimini değiştirmemiz gerekir.**

Skor ve haberi iki bağımsız kaynaktan almak daha uygun. Skorlar API'den; haberler öncelikle yayıncının izin verdiği RSS/Atom akışından alınacak. RSS/Atom, haber listesini makinenin okuyabileceği XML biçiminde sunar; ücretli haber API'si zorunlu değildir. Skor için maç olayı ve gecikme; haber için Türkçe kaynak kalitesi, yayın izni ve haberi ne kadar erken bulduğu belirleyicidir.

- **En düşük maliyetli başlangıç:** Highlightly All Sports PRO + ticari mobil kullanımına ücretsiz izin alınan RSS kaynakları. Yalnız veri abonelikleri **12,49 USD/ay** olabilir; RSS izni henüz alınmış değildir. Seçili spor/ligler ve kota kontrollü sorgulama gerekir. Bu yolun skor hızı dakikalık düzeydedir.
- **Daha geniş takip:** Aynı RSS yapısı + Highlightly ULTRA: yalnız veri abonelikleri **25,99 USD/ay**. Daha yüksek kota sağlar, kaynak verisini daha hızlı güncellemez.
- **Haber için yedek seçenek:** RSS izinleri veya kapsamı uygun çıkmazsa The News API; ticari kullanım koşulu netleşmezse ticari yayına açık GNews Essential. Tek JSON API entegrasyonu teknik olarak daha kolay olabilir; RSS ise uygun izinle abonelik maliyetini azaltır.
- **Saniyeler düzeyinde skor önceliği:** Goalserve'i öncelikli spor/liglerde denemek ve sınırlı kapsam için fiyat almak. Tüm spor paketi pahalıdır. Haber yine ayrı kaynaktan gelir.
- **Daha ileri ticari seçenek:** Sportradar'ın ilgili sporlar için canlı akış paketi. Fiyat, lig kapsamı ve erişim ayrıca teklif gerektirir.

**Mevcut araştırmada hem bütün istenen sporları hem saniyelik skorları hem de güncel Türkçe haberleri ücretsiz ve ticari yayına uygun şekilde karşılayan bir paket doğrulanmadı.** “Maçkolik'teki her şey” ifadesi yerine desteklenecek spor ve lig listesi çıkarılmalı; hiçbir aday için birebir eşdeğer kapsam doğrulanmış değil.

## 2. Çoklu spor skor kaynakları

| Aday | Kapsam | Hız hakkında doğrulanan bilgi | Aylık fiyat / karar |
|---|---|---|---|
| **Highlightly All Sports** | Futbol, basketbol, voleybol, hentbol, buz hokeyi, beyzbol, Amerikan futbolu, kriket, rugby. NBA/NHL ayrı modülleri ek spor sayılmaz. Tenis, F1 ve MMA listelenmiyor. | Futbol, basketbol, voleybol ve hokey `matches` listeleri için dokümanda **dakikada bir yenileme** yazıyor. Diğer uçların aynı hızda olduğu varsayılmamalı. | PRO **12,49 USD / 7.500 istek/gün**; ULTRA **25,99 USD / 25.000 istek/gün**. Düşük bütçe için aday; saniyelik skor vaadine uygun değil. |
| **Goalserve** | Futbol, basketbol, voleybol yanında tenis, motor sporları, MMA ve diğer branşları içeren geniş katalog. Hedef lig/alanlar ayrıca doğrulanmalı. | Resmî FAQ, **çoğu sporda 2–4 saniyelik skor güncellemesi** bildiriyor. Bu, olayın sahadan uygulamaya 2–4 saniyede ulaşacağı garantisi değildir. | Full Package / All Sports **800 USD/ay**. Voleybol paketi tek başına **100 USD/ay**. Az sayıda öncelikli spor için ayrı teklif değerlendirilir. |
| **Sportradar** | Çok geniş spor kataloğu; lig ve veri derinliği ürüne göre değişiyor. | NBA ve global basketbol gibi ürünlerde Push Feeds belgelenmiş. NBA akışı HTTP üzerinden sürekli veri bağlantısıdır; erişim ek hizmettir. Bütün sporlar için aynı destek veya saniye garantisi doğrulanmadı. | Bu araştırmada uygun paketin açık fiyatı doğrulanmadı; teklif ve deneme gerekir. Düşük bütçeli ilk tercih değil. |

Kaynaklar: [Highlightly kapsam/fiyat](https://highlightly.net/sport-api/), [Highlightly uç bazında yenileme](https://highlightly.net/sport-api/documentation/), [Goalserve kapsam ve hız FAQ](https://www.goalserve.com/), [Goalserve tüm spor fiyatı](https://www.goalserve.com/en/sport-data-feeds/full-package-api/prices), [Goalserve voleybol fiyatı](https://www.goalserve.com/en/sport-data-feeds/volleyball-api/prices), [Sportradar ürün kataloğu](https://developer.sportradar.com/), [NBA Push Feeds](https://developer.sportradar.com/basketball/reference/nba-push-feeds).

**İki kritik ayrım:** Goalserve fiyat sayfasındaki 200 USD'lik WebSocket eklentisi **canlı bahis oranları** için açıklanıyor; skor akışı desteği olarak kabul edilmemeli. Sportradar NBA dokümanındaki 5 saniyelik heartbeat ise bağlantının açık olduğunu gösterir; skorun sahadan gelme gecikmesi değildir.

API-Sports ve BetsAPI'nin resmî sayfalarına erişim sorunu nedeniyle bu incelemede güncel paketlerini yeterince doğrulayamadım. Bu sağlayıcıları kötü oldukları için değil, doğrulanmış fiyat/hız karşılaştırmasına koyamadığım için kısa liste dışında tuttum.

### Lig kapsamını nasıl doğrulayacağız?

| Spor grubu | Deneme sırasında kontrol edilecek örnekler |
|---|---|
| Futbol | Süper Lig, 1. Lig, Avrupa kupaları, öncelikli yabancı ligler; skor + olaylar + fikstür + puan durumu |
| Basketbol | Türkiye Basketbol Süper Ligi, EuroLeague, NBA; periyot, skor düzeltmesi, uzatma ve sıralama |
| Voleybol | Sultanlar Ligi, Efeler Ligi, CEV; setler, set içi sayılar, maç sonucu ve puan durumu |
| Diğer sporlar | ATP/WTA, F1, UFC/MMA ve istenen diğer organizasyonlar tek tek; spor adının katalogda bulunması yeterli değil |

Bu tablo sağlayıcıların bu ligleri eksiksiz verdiği iddiası değildir; satın alma öncesi kabul listesidir. Her ligde canlı kapsam, sezon, kadın/erkek kategorisi ve tarihsel veri ayrı kontrol edilir.

## 3. Türkçe ve çoklu spor haber kaynakları

### Öncelikli seçenek: yayıncıların RSS/Atom akışları

| Kaynak | Doğrulanan durum | Uygulamada kullanım kararı |
|---|---|---|
| **NTV Spor** | Resmî RSS sayfasında futbol, basketbol, voleybol, tenis, motor sporları ve diğer sporlar var. Futbol akışı bu araştırmada açıldı; başlık, özet, tarih ve kaynak bağlantısı içeriyor. Akış teknik olarak Atom biçiminde. | Çoklu spor için ilk aday. Kullanım koşulları içerik kullanımında yazılı izin istiyor; ticari Android uygulamasında hangi alanların kullanılacağı netleştirilmeli. |
| **SonDakika.com** | Sitenin bağlantı verdiği genel RSS akışı çalışıyor. Bu incelemede ayrı spor akışının adresi doğrulanmadı; genel akışın spor/transfer haberlerini eksiksiz kapsadığı varsayılmayacak. | Şartlarda başlık/spotun kaynakla web sitesi ve forumlarda kullanımı açıklanıyor. Mobil uygulama kapsamı ayrıca teyit edilmeli; tam metin ve fotoğrafları serbest kabul etmiyoruz. |

Kaynaklar: [NTV Spor RSS listesi](https://www.ntvspor.net/rss), [futbol akışı](https://www.ntvspor.net/rss/kategori/futbol), [NTV Spor kullanım koşulları](https://www.ntvspor.net/kullanim-kosullari), [SonDakika.com](https://www.sondakika.com/), [SonDakika.com kullanım şartları](https://www.sondakika.com/kullanim-sartlari/).

**RSS'ye erişimin ücretsiz olması, içeriği ticari uygulamada yeniden yayımlama izni değildir.** Haber bedelini sıfır kabul etmemizin koşulu, kullanılacak alanlar için ücretsiz izin bulunmasıdır. Henüz hiçbir yayıncıyla anlaşma yapılmadı. Sadece kaynak bağlantısı vermek de her türlü metin/görsel kullanımını otomatik olarak serbest yapmaz.

**En kolay RSS başlangıcı:** İzin uygun çıkarsa tek yayıncıdan, öncelikle NTV Spor'un futbol/basketbol/voleybol akışlarından başlamak. Bir genel haber sitesini kazıyıp spor haberlerini ayırmak yerine yayıncının hazır spor akışlarını kullanmak daha az bakım gerektirir. Transfer haberleri futbol akışından gelebilir; ayrı transfer akışı veya bütün transferleri yakalama garantisi doğrulanmadı. Resmî açıklama ile transfer iddiası aynı şekilde etiketlenmeyecek.

### Dış veriyi nasıl alacağız?

1. **Skor:** Dart backend, anahtarı Secret Manager'da tutarak Highlightly REST uçlarını çağırır. Maç, olay, fikstür, puan durumu ve takım kayıtları ortak modele çevrilir; yalnız değişiklikler Firestore'a yazılır. API anahtarı Flutter'a konmaz.
2. **Skor zamanlaması:** Seçili canlı spor uçları için başlangıç hedefi 60 saniyedir; PRO kotasına sığmazsa kapsam/sıklık azaltılır veya ULTRA seçilir. Fikstür, sıralama ve takım bilgileri ayrı, daha seyrek işlerdir. Sayfalama ve detay sorguları bütçeye dahil edilir.
3. **Haber:** Backend yalnız tanımlı yayıncı akışlarını RSS/Atom okuyucusuyla alır. Başlangıç önerisi, yayıncının koşullarına göre **10–15 dakikada bir**; izin ve ihtiyaç uygunsa 5 dakika. Her kullanıcı için ayrı dış sorgu yapılmaz.
4. **Haber kaydı:** Yayıncı kimliği + GUID/Atom ID veya standart kaynak URL'siyle tekrar önlenir. İzinli başlık/özet, yayıncı, orijinal URL, yayın/güncelleme ve alınma zamanı tutulur. Görsel izni yoksa görselsiz kart gösterilir; tam yazı ayrıca çekilmez.
5. **Ekran:** Flutter Firestore'dan haber kartlarını okur. Kullanıcı dokununca orijinal haber tarayıcıda/Android Custom Tab'de açılır. Kaynaktan gelen HTML doğrudan çalıştırılmaz; izinli metin alanları temizlenir.
6. **Dayanıklılık:** Kaynak destekliyorsa ETag/Last-Modified ile koşullu sorgu yapılır; hata halinde artan bekleme ve sınırlı yeniden deneme uygulanır. Son içerik izin verilen saklama süresince korunur; güncellik zamanı gösterilir. Kaynak bazında açma/kapama ayarı bulunur.

Bu yapı transfer, basketbol, voleybol ve diğer spor haberlerini aynı haber modeline alır. Branş önce kaynak kategorisinden belirlenir; takım/transfer eşleştirmesi belirsizse zorla etiketlenmez. HTML sayfa kazıma ilk çözüm değildir.

### RSS uygun çıkmazsa haber API alternatifleri

| Aday | Hız ve kapsam | Fiyat / sınır | Futbolix için değerlendirme |
|---|---|---|---|
| **The News API** | Türkçe `tr` ve `sports` kategorisi destekleniyor. Real-time veri sunulduğu belirtiliyor; yayıncıdan kaç saniyede toplandığına ilişkin garanti doğrulanmadı. | Basic **19 USD/ay**, 2.500 istek/gün, istekte 25 makale. Ücretsiz plan 100 istek/gün ve 3 makale/istek. | **En düşük maliyetli deneme adayı.** Türkçe basketbol/voleybol ve diğer sporların kaynak kalitesi canlı örneklerle ölçülmeli. Ticari uygulamada kullanım ve saklama izni ayrıca netleştirilmeli. |
| **GNews Essential** | Türkçe `tr`, Türkiye `tr` ve `sports` filtresi var. Ücretli pakette real-time article availability belirtiliyor; yayıncının yazdığı andan itibaren saniye garantisi değil. | **49,99 EUR/ay**, 1.000 istek/gün, istekte 25 makale. Ücretsiz sürüm **12 saat gecikmeli**, ticari projeye uygun değil. | **Ticari yayın izni paket sayfasında açık olan alternatif.** Türkçe çoklu spor içerik kalitesi yine test edilmeli. |
| **NewsData.io** | Ücretli Basic'te real-time veri sunuluyor. Ücretsiz sürümde 12 saat gecikme var. | Basic **199,99 USD/ay**; 20.000 kredi/ay. Kredi hesabı diğer sağlayıcıların günlük istek kotasıyla aynı kabul edilmemeli. | Mevcut düşük bütçe hedefinde ilk tercih değil. Daha pahalı olması daha erken Türkçe haber garantisi sağlamaz. |
| **Sportradar Editorial** | Haber/analiz ürünü var; açıklanan kapsam büyük ABD sporları ve uluslararası futbol ağırlıklı. | Ayrı erişim/paket gerekir; bu incelemede fiyat ve Türkçe kapsam doğrulanmadı. | Skorla aynı firma olabilir ama Türkçe ve bütün branşlarda haber ihtiyacımızı otomatik karşılamaz. |

Kaynaklar: [The News API fiyat](https://www.thenewsapi.com/pricing), [dil ve kategori dokümanı](https://www.thenewsapi.com/documentation), [kullanım koşulları](https://www.thenewsapi.com/tos), [GNews fiyat ve ticari kullanım](https://gnews.io/pricing), [GNews Türkçe ve spor filtreleri](https://docs.gnews.io/endpoints/top-headlines-endpoint), [NewsData.io fiyat](https://newsdata.io/pricing), [Sportradar Editorial kapsamı](https://developer.sportradar.com/images-and-editorials/reference/editorial-overview).

The News API'nin genel kullanım koşullarından bu müşteri uygulamasının ticari kullanım ve içerik saklama hakkını kesinleştiremedim. Bu, hizmetin ticari kullanımı yasakladığına dair kesin bir sonuç değil; **19 USD'lik seçeneği üretime geçiş için koşullu öneriyorum.** Basic için tüm planlarda açılan `/v1/news/all` kullanılabilir; dokümana göre `/headlines` Standard ve üzeri gerektirir.

Hiçbir haber paketinde “tam metin geliyor” ifadesini tüm yazıyı ve fotoğrafı yeniden yayımlama izni saymayacağız. Başlangıç tasarımı: izin verilen başlık/özet/görsel, kaynak adı, tarih ve orijinal habere bağlantı. Genel `sports` kategorisi takım kimliği veya branş etiketini her kayıtta garanti etmez; belirsiz haber genel spor akışında kalır.

## 4. Kullanıcı ne kadar gecikme görecek?

**Skor gecikmesi = sahadaki olayın sağlayıcıya işlenmesi + API'nin yayımlama/önbellek beklemesi + bizim sorgu beklememiz + backend/ağ/ekran süresi.** Sağlayıcının verdiği süre bunların birden fazlasını kapsıyorsa iki kez toplanmaz.

| Yapı | Gerçekçi yorum |
|---|---|
| Highlightly'nin dakikalık maç listesi + bizim 60 saniyelik sorgumuz | İki bağımsız yenileme döngüsü toplamda yaklaşık 0–120 saniye bekleme ekleyebilir. Buna kaynağın olayı toplama ve iletim süresi eklenir. **Yaklaşık 1–2 dakika bir planlama tahminidir; üst sınır veya garanti değildir.** |
| Goalserve'in belirtilen 2–4 saniyelik yenilemesi + uygun kotayla 5 saniyelik sorgu | Sorgudan kaynaklanan ek bekleme yaklaşık 0–5 saniyedir. Saniyeler düzeyinde deneyim için daha uygun aday; **toplam 5 saniye** sözü verilemez. Her hedef ligde ölçüm gerekir. |
| Sağlayıcının desteklediği canlı skor akışı | Periyodik sorgu beklemesi azalır. Kaynağın veri toplama gecikmesi, bağlantı kesintisi ve telefona teslim süresi devam eder. |
| Haberleri 5 dakikada bir ortak sorgulama | Haber **API'de erişilebilir olduktan sonra** sorgu kaynaklı 0–5 dakika bekleme eklenir. Haberin yayıncıda çıkışı ile API'ye girişi arasındaki süre ayrıca ölçülür. |

Hızlı skor seçeneği için önerilen kabul hedefi: öncelikli liglerde **toplam gecikmenin p95 değerini 10–15 saniye içinde tutabilmek**. Bu henüz doğrulanmamış ürün hedefidir; sağlayıcı denemesi sonucu değiştirilir. Backend'in veriyi aldığı andan açık ekranda gösterilmesine kadar geçen süre ayrıca ölçülür. Push bildirimleri, telefonun çevrimdışı olması veya pil kısıtları nedeniyle ek gecikebilir.

Basketbol ve voleybolda bir dakika içinde birkaç sayı değişebilir. Dakikalık skor görüntüsünden bütün ara olayları üretmeye çalışmayacağız; olay bildirimi gerekiyorsa sağlayıcının olay akışı kullanılacak. Sohbetin açılıp kapanması da aldığımız gerçek maç durumunun tazeliğine bağlıdır.

## 5. Kota ve aylık API bütçesi

Kullanıcı sayısı tek başına dış API masrafını belirlemez. Ortak backend sayesinde aynı maçı 50 kişinin izlemesi 50 ayrı sağlayıcı sorgusu oluşturmaz. Maliyeti spor sayısı, sayfalama, detay uçları ve sorgu sıklığı belirler.

**Örnek skor hesabı:** Dokuz spor için her sorgunun tek sayfada tamamlandığını varsayarsak:

- 24 saat boyunca dakikada bir: `9 × 1.440 = 12.960 istek/gün`.
- NBA/NHL gibi ek uçlar, sayfalama, olay detayları ve fikstür çağrıları bu hesabı artırır.
- Dolayısıyla **PRO'nun 7.500 isteği bu senaryoya yetmez**. ULTRA'nın 25.000 kotası ilk test için daha uygun adaydır; bütün liglerde yeterli olduğu henüz kanıtlanmış değildir.
- Dokuz sporu 10 saniyede bir sorgulamak: `9 × 8.640 = 77.760 istek/gün`. Dakikalık yenilenen veriye bunu yapmak hız kazandırmadan kotayı tüketir.

**RSS hesabı:** Üç spor akışını 15 dakikada bir okumak `3 × 96 = 288 HTTP isteği/gün` yapar. Bu, ücretli haber API kotası değildir; yine de yayıncının erişim sınırlarına uyulur ve backend işlem/ağ maliyeti oluşabilir. Akışların sınırlı geçmişi yüzünden sorgular arasında haber kaçırılması test edilir.

**Haber API'sine geçilirse:** Tek ortak spor sorgusu 5 dakikada bir `288 istek/gün`; her seferinde iki sayfa `576 istek/gün`. Dokuz sporu ayrı ayrı aynı sıklıkta sorgulamak ise sayfalama olmadan `2.592 istek/gün` yapar. Bu yüzden başlangıçta ortak akış, tekrarları ayıklama ve gerektiğinde sınırlı ek sorgular kullanılacak. “Top headlines” bütün yayımlanan haberlerin eksiksiz listesi sayılmayacak.

| Senaryo | Yalnız aylık API bedeli | Sınırı |
|---|---|---|
| **Önerilen ucuz başlangıç: Highlightly PRO + izinli ücretsiz RSS** | **12,49 USD** | Ücretsiz mobil yayın izni şart. Seçili spor/ligler, 7.500 istek/gün; tüm sporları sürekli tarama taahhüdü yok. |
| **Daha geniş takip: Highlightly ULTRA + izinli ücretsiz RSS** | **25,99 USD** | Aynı izin şartı; 25.000 istek/gün. Tenis/F1/MMA dahil değil; hız PRO ile aynı kaynak yenilemesine bağlı. |
| Seçili spor/saatler: Highlightly PRO + The News API Basic | **31,49 USD** | Haber kullanım izni ve kalite testi şart; tüm sporları sürekli tarama bütçesi değildir. |
| Daha geniş dakikalık takip: Highlightly ULTRA + The News API Basic | **44,99 USD** | Aynı haber doğrulaması şart. 9 spor kapsamı; tenis/F1/MMA ek maliyeti dahil değil. |
| Daha geniş dakikalık takip + açık ticari haber paketi: Highlightly ULTRA + GNews Essential | **25,99 USD + 49,99 EUR** | İki ayrı para birimi; bütün ligler ve içerik hakları ayrıca doğrulanır. |
| Geniş kapsam ve hızlı skor adayı: Goalserve Full Package + GNews Essential | **800 USD + 49,99 EUR** | Hedef liglerin veri kapsamı ve gecikmesi test edilmeli. Düşük bütçeli ilk sürüm için pahalı. |

**Bunlar proje toplamı değildir.** Vergiler, kur/ödeme farkları, Cloud Run, Firestore, Scheduler, loglama, diğer bulut servisleri ve gerekiyorsa ek veri lisansları dahil değil. Sürekli çalışan skor işleyicisini ücretsiz varsaymayacağız. Yalnız API bedeli düşük diye bütün sistemin ücretsiz çalışacağı sonucu çıkmaz.

## 6. Mimari aynı mı kalıyor?

**Ana omurga ve klasör yapısı kalabilir; işleyicinin çalışma biçimi, veri modeli ayrıntıları ve maliyet ayarları kaynak seçimine göre değişir.**

```text
Highlightly REST → Dart spor adaptörü ─────┐
                                         ├→ Normalleştirme → Firestore → Flutter
İzinli RSS/Atom → Dart haber adaptörü ─────┘
Haber API (yedek) → aynı haber modeli
Yeni spor olayı → kalıcı bildirim işi → FCM

Dakikalık sürüm: Cloud Scheduler → yetkili Dart veri işleyici
Hızlı sürüm:    sürekli skor işleyici / desteklenen canlı akış
RSS haberler: ayrı 10–15 dakikalık zamanlama; izin/ihtiyaca göre 5 dakika
```

| Bölüm | Karar |
|---|---|
| Flutter, Riverpod, go_router | Kalır. Spor türüne göre ekran ve skor gösterimi değişir. |
| Firebase Auth, Firestore, FCM | Başlangıçta kalır. Değişiklik sıklığı ve dinleyen kullanıcı sayısıyla okuma/yazma maliyeti ölçülür. |
| Dart backend ve `integrations/` | Kalır. `SportsProvider` / `NewsProvider` arayüzleri ayrılır. Highlightly adaptörü ve RSS/Atom haber adaptörü eklenir; yedek haber API'si aynı haber modelini kullanır. Sağlayıcı JSON/XML'i doğrudan mobil uygulamaya yayılmaz. |
| Zamanlanmış veri işleyici | Dakikalık veri için mevcut yapı uygun. Saniyelik hedefte çalışma biçimi değiştirilir; Cloud Scheduler tek başına 5 saniyelik tetikleyici değildir. |
| Sürekli bağlantı / sık sorgulama | Gerekirse Cloud Run'da instance-based billing ve minimum instance ile çalışan işleyici değerlendirilir. Yeniden başlama, bağlantı yenileme ve eksik veriyi tamamlama zorunludur. |
| Webhook | Yalnız seçilen skor paketinde gerçekten varsa kullanılır; imza/yetki doğrulanır. HTTP canlı akışı webhook ile aynı şey değildir. |
| Model ve sağlayıcı değişimi | İç maç/takım kimlikleri sabit kalır; sağlayıcı kimlikleri eşlenir. Böylece favoriler ve sohbet odaları sağlayıcı değişiminde parçalanmaz. |
| Haberler | RSS/Atom okuma, normalleştirme, URL/kimlik ile tekrar önleme, kaynak ve zaman alanları. Başlangıç 10–15 dakika; izin/ihtiyaç uygunsa 5 dakika. |
| Bildirim ve sohbet | Mevcut kalıcı bildirim işi, tekrar önleme ve moderasyon korunur. Geciken/eski maç durumları, skor düzeltmesi ve maç bitişi yarışları ele alınır. |

Cloud Scheduler'ın cron alanları dakika düzeyindedir. Cloud Run'da istek bazlı CPU tahsisi, yanıt döndükten sonra güvenilir bir sonsuz döngü kurmak için uygun değildir. Instance-based çalışma minimum instance ile birleştirilebilir; yine de örnekler kapanabilir ve yeniden başlatılabilir. Kaynaklar: [Scheduler zamanlama](https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules), [Cloud Run faturalandırma ve arka plan çalışması](https://cloud.google.com/run/docs/configuring/billing-settings).

İlk seçenek, mevcut iki dağıtımdaki veri işleyicinin çalışma biçimini değiştirmektir; sırf sağlayıcı değişti diye mikroservis sayısını artırmak gerekmiyor. Sürekli akış ile haber/temizlik işlerinin farklı ölçeklenmesi gerekirse ayrı işleyici dağıtımı eklenebilir. Tek aktif tüketici için kilit/lease ve tekrar işleme koruması düşünülmeli; bağlantı koptuğunda REST ile güncel durum tamamlanmalı. Sportradar NBA akışı kaçırılan veriyi hatırlayan bir oturum sağlamıyor.

Çoklu spor modeli yalnız `evSahibiGol / deplasmanGol` olmamalı: basketbolda periyot/uzatma, voleybol ve teniste setler, motor sporlarında sıralama/tur gibi alanlar gerekir. Bir sağlayıcı eklemek bazen yalnız adaptör değil, yeni spor modeli ve ekran geliştirmesidir.

**Bu öneri ana proje planının v4.1 sürümüne işlendi: ilk seçenek izinli RSS/Atom, alternatif uygun ücretsiz veya ücretli Haber API'sidir.** RSS için yayıncı koşullarıyla 10–15 dakika, gerekirse 5 dakika değerlendirilir; API zamanlaması kendi kotasına göre seçilir. Yeni servis veya ayrı veritabanı gerekmez. Spor senkronizasyonu, haber senkronizasyonu ve bildirim gönderimi birbirini beklememeli. Omurganın uygun olması henüz ölçülmüş hız garantisi değildir.

## 7. Seçimi kesinleştirecek görevler

- [ ] Yayınlanacak sporları ve öncelikli ligleri listele; “tüm sporlar” kapsamını isimlerle tanımla.
- [ ] Her lig için canlı skor, olaylar, fikstür, sıralama, takım/sporcu ve logo kapsamını kontrol et.
- [ ] Highlightly ile futbol, basketbol ve voleybolda birkaç canlı maç izle; eksik sayıları ve veri gecikmesini kaydet.
- [ ] Hız hedefi karşılanmıyorsa aynı maçlar için Goalserve deneme erişimi ve öncelikli spor paketi fiyatını doğrula; gerekiyorsa Sportradar akışını karşılaştır.
- [ ] Önce NTV Spor, alternatif SonDakika.com için ticari Android kullanımını, başlık/özet/görsel haklarını, saklama süresini ve ücretsiz izin durumunu netleştir.
- [ ] İzinli RSS kaynaklarını/adreslerini kaydet; futbol, basketbol, voleybol ve transfer haberlerinin gerçek kapsamını dene.
- [ ] Dart RSS/Atom adaptörünü, aynı haber modelini, tekrar önlemeyi ve kaynak bağlantısını açan Flutter kartını uygula.
- [ ] 10–15 dakikalık RSS sorgusunda haber kaybını, bozuk akışı ve kesintiyi test et; yayıncı koşullarına göre sıklığı ayarla.
- [ ] RSS uygun çıkmazsa The News API'nin Türkçe kapsamı ve ticari iznini doğrula; karşılanmazsa GNews Essential değerlendir.
- [ ] Haber örneklerinde yayıncı zamanı, RSS/API'de ilk görülme zamanı ve uygulamaya yazılma zamanını ayrı kaydet; kaynaktaki gecikmeyi bizim gecikmemiz sanma.
- [ ] Skorda sağlayıcı zaman damgasının neyi temsil ettiğini doğrula; `providerUpdatedAt`, `receivedAt`, `storedAt`, `displayedAt` zamanlarını ölç. TV yayını gecikebildiği için tek başına gerçek olay saati kabul etme.
- [ ] Gecikmenin ortanca ve p95 değerlerini spor/lig bazında çıkar; yalnız en hızlı tek olayı raporlama.
- [ ] Gerçek sayfalama ve detay çağrılarıyla günlük kota hesabı çıkar; normal tüketimde en az %20 pay bırakmayı hedefle.
- [ ] Polling veya canlı akış kararını ve Cloud Run çalışma/maliyet ayarlarını kesinleştir.
- [ ] Veri kesintisi, eski veri, maç bitişi, VAR/skor düzeltmesi, bağlantı kopması ve yinelenen olayları test et.
- [ ] Seçilen sağlayıcıları, gerçek kapsamı ve ölçülen süreleri ana proje planına işle; ardından müşteriyle hız beklentisini kesinleştir.

**Güncel ilk adım:** Ücretli paket almadan ücretsiz kaynakları doğrulamak ve UI geliştirmesini örnek verilerle başlatmak. Yukarıdaki ücretli seçenekler yalnız maliyet karşılaştırması olarak korunmuştur; sıfır abonelik hedefini karşılamaz. Kaynak kararı ve kapsam için ücretsiz veri eki esas alınır.
