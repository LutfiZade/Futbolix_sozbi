/// Offline preview data. No scores, news or profiles here come from live APIs.
class DemoTeam {
  const DemoTeam(
    this.id,
    this.name,
    this.shortName,
    this.league,
    this.rank, {
    this.players = '',
  });
  final String id, name, shortName, league, players;
  final int rank;
}

enum Sport { football, basketball, volleyball, tennis }

class DemoMatch {
  const DemoMatch(
    this.id,
    this.league,
    this.sport,
    this.homeId,
    this.awayId,
    this.homeName,
    this.awayName,
    this.homeScore,
    this.awayScore,
    this.clock, {
    this.event = '',
    this.live = true,
  });
  final String id, league, homeId, awayId, homeName, awayName, clock, event;
  final int homeScore, awayScore;
  final Sport sport;
  final bool live;
}

class DemoArticle {
  const DemoArticle(
    this.id,
    this.category,
    this.title,
    this.source,
    this.age,
    this.teamId,
    this.summary,
  );
  final String id, category, title, source, age, teamId, summary;
}

const demoTeams = [
  DemoTeam(
    'gs',
    'Galatasaray',
    'G.Saray',
    'Süper Lig',
    1,
    players: 'Icardi Osimhen',
  ),
  DemoTeam('fb', 'Fenerbahçe', 'F.Bahçe', 'Süper Lig', 2, players: 'Tadic'),
  DemoTeam('bjk', 'Beşiktaş', 'Beşiktaş', 'Süper Lig', 4),
  DemoTeam('ts', 'Trabzonspor', 'Trabzonspor', 'Süper Lig', 3),
  DemoTeam('basak', 'Başakşehir', 'Başakşehir', 'Süper Lig', 6),
  DemoTeam('samsun', 'Samsunspor', 'Samsunspor', 'Süper Lig', 5),
  DemoTeam('konya', 'Konyaspor', 'Konyaspor', 'Süper Lig', 7),
  DemoTeam('rize', 'Ç. Rizespor', 'Ç. Rizespor', 'Süper Lig', 10),
  DemoTeam('goztepe', 'Göztepe', 'Göztepe', 'Süper Lig', 8),
  DemoTeam(
    'city',
    'Manchester City',
    'Man City',
    'Premier Lig',
    1,
    players: 'Haaland',
  ),
  DemoTeam('arsenal', 'Arsenal', 'Arsenal', 'Premier Lig', 2),
];

const demoMatches = [
  DemoMatch(
    'derby',
    'Süper Lig',
    Sport.football,
    'gs',
    'fb',
    'Galatasaray',
    'Fenerbahçe',
    2,
    1,
    "74'",
    event: "67' Sarı kart · Oosterwolde (FB)",
  ),
  DemoMatch(
    'trabzon',
    'Süper Lig',
    Sport.football,
    'ts',
    'bjk',
    'Trabzonspor',
    'Beşiktaş',
    1,
    0,
    "38'",
    event: "35' Gol · Trabzonspor",
  ),
  DemoMatch(
    'city',
    'Premier Lig',
    Sport.football,
    'city',
    'arsenal',
    'Man City',
    'Arsenal',
    3,
    1,
    "85'",
    event: "82' Oyuncu değişikliği · Arsenal",
  ),
  DemoMatch(
    'efes',
    'EuroLeague',
    Sport.basketball,
    'efes',
    'pao',
    'Anadolu Efes',
    'Panathinaikos',
    71,
    68,
    '3. periyot',
    event: 'Son sayı · Anadolu Efes',
  ),
  DemoMatch(
    'vakif',
    'Sultanlar Ligi',
    Sport.volleyball,
    'vakif',
    'gsv',
    'VakıfBank',
    'Galatasaray Daikin',
    2,
    1,
    '4. set',
    event: 'Set içi skor · 18 – 16',
  ),
  DemoMatch(
    'tennis',
    'ATP Finals',
    Sport.tennis,
    'sinner',
    'alcaraz',
    'J. Sinner',
    'C. Alcaraz',
    1,
    1,
    '3. set',
    event: 'Set içi oyun · 4 – 3',
  ),
  DemoMatch(
    'tomorrow',
    'Süper Lig',
    Sport.football,
    'basak',
    'samsun',
    'Başakşehir',
    'Samsunspor',
    0,
    0,
    'Yarın\n20:00',
    live: false,
  ),
];

const demoArticles = [
  DemoArticle(
    'transfer',
    'Transfer',
    'Galatasaray, Ajax forması giyen genç stoper için resmi teklifini iletti',
    'Fanatik',
    '22 dk önce',
    'gs',
    'Sarı-kırmızılı ekip, savunma hattını güçlendirmek için çalışmalarını sürdürüyor. Transfer sürecine ilişkin gelişmeler bu alanda gösterilecek.',
  ),
  DemoArticle(
    'injury',
    'Süper Lig',
    "Fenerbahçe'de sakatlık şoku: Tadic 3 hafta yok",
    'NTV Spor',
    '48 dk önce',
    'fb',
    'Takımın sağlık durumuna ilişkin haberler, kaynak bağlantısı ve yayın tarihiyle birlikte bu alanda yer alacak.',
  ),
  DemoArticle(
    'europe',
    'Avrupa',
    'Şampiyonlar Ligi kura çekimi bugün: Muhtemel rakipler',
    'UEFA',
    '1 sa önce',
    'real',
    'Avrupa kupalarında eşleşmeler ve kulüplerin olası rakipleri için hazırlanan örnek haber görünümü.',
  ),
  DemoArticle(
    'national',
    'Milli Takım',
    'A Milli Takım aday kadrosu açıklandı, 4 yeni isim var',
    'TFF',
    '2 sa önce',
    'turkiye',
    'Milli takım kadrosu, maç programı ve federasyon açıklamaları bu bölümde gösterilecek.',
  ),
  DemoArticle(
    'trabzon-news',
    'Süper Lig',
    'Trabzonspor deplasmanda serisini 7 maça çıkardı',
    'Spor Servisi',
    '3 sa önce',
    'ts',
    'Karşılaşmanın öne çıkan anları ve takım haberleri için örnek içerik.',
  ),
];

String normalizedSearch(String input) => input
    .toLowerCase()
    .replaceAll('ı', 'i')
    .replaceAll('ş', 's')
    .replaceAll('ğ', 'g')
    .replaceAll('ü', 'u')
    .replaceAll('ö', 'o')
    .replaceAll('ç', 'c');
