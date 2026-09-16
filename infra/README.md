# Altyapı

Cloud Run, Scheduler, IAM ve Secret Manager ayarları proje kurulurken burada tanımlanacak. Henüz bulut kaynağı oluşturulmadı.

İlk kurulumda Cloud Run, Firestore ve log tüketimi için bütçe/maliyet uyarıları kurulacak. Sohbet okuma/yazması ayrı izlenecek. Bütçe uyarısı otomatik harcama sınırı değildir; kaynak limitleri ve işletme müdahalesi ayrıca planlanır.

Dakikalık sorgu için Scheduler; saniyelik veya sürekli bağlantı gerekirse uygun işleyici çalışma biçimi ve maliyeti ayrıca doğrulanır. Ücretsiz dış veri, Cloud Run'ın sürekli çalışmasını ücretsiz yapmaz.
