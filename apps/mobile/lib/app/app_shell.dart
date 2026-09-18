import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/demo/demo_data.dart';
import '../features/events/presentation/matches_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/news/presentation/news_page.dart';
import '../features/participants/presentation/teams_page.dart';
import '../features/settings/presentation/more_page.dart';
import '../shared/widgets/team_badge.dart';
import '../shared/widgets/ui_components.dart';
import 'demo_store.dart';
import 'theme/app_theme.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.store});
  final DemoStore? store;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late final DemoStore _store = widget.store ?? DemoStore();
  int _index = 0;
  static const _labels = [
    'Ana Sayfa',
    'Maçlar',
    'Haberler',
    'Takımlar',
    'Daha Fazla',
  ];
  static const _icons = [
    Icons.home_outlined,
    Icons.sports_soccer_outlined,
    Icons.newspaper_outlined,
    Icons.shield_outlined,
    Icons.more_horiz_rounded,
  ];

  @override
  void dispose() {
    if (widget.store == null) _store.dispose();
    super.dispose();
  }

  void _select(int index) {
    FocusScope.of(context).unfocus();
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _store,
    builder: (context, _) => PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _select(0);
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF10251B),
                AppColors.background,
                AppColors.background,
              ],
              stops: [0, .2, 1],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                PageHeader(
                  title: _labels[_index],
                  greeting: _index == 0,
                  onNotifications: _openNotifications,
                  onProfile: _openProfile,
                  unread: _store.unreadNotifications,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _index,
                    children: [
                      HomePage(
                        store: _store,
                        onTeams: () => _select(3),
                        onMatches: () => _select(1),
                        onMatch: _openMatch,
                        onBreakingNews: () => _openMatch(demoMatches.first),
                      ),
                      MatchesPage(store: _store, onMatch: _openMatch),
                      NewsPage(onArticle: _openArticle),
                      TeamsPage(store: _store, onTeam: _openTeam),
                      MorePage(
                        store: _store,
                        onTeams: () => _select(3),
                        onMatches: () => _select(1),
                        onNews: () => _select(2),
                        onProfile: _openProfile,
                        onSetting: _openSetting,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0B1210).withValues(alpha: .97),
                border: const Border(
                  top: BorderSide(color: Color(0xFF1D2923), width: .6),
                ),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 66,
                  child: Row(
                    children: [
                      for (var i = 0; i < _labels.length; i++)
                        Expanded(
                          child: Semantics(
                            selected: _index == i,
                            button: true,
                            label: _labels[i],
                            excludeSemantics: true,
                            child: InkWell(
                              key: ValueKey('nav-$i'),
                              onTap: () => _select(i),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _icons[i],
                                    size: 23,
                                    color: _index == i
                                        ? AppColors.lime
                                        : AppColors.muted,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _labels[i],
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: _index == i
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                      color: _index == i
                                          ? AppColors.lime
                                          : AppColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _sheet(String title, Widget Function(BuildContext) content) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              0,
              20,
              22 + MediaQuery.viewInsetsOf(sheetContext).bottom,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(sheetContext).height * .78,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Kapat',
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: SingleChildScrollView(
                      child: AnimatedBuilder(
                        animation: _store,
                        builder: (context, _) => content(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _openMatch(DemoMatch match) => _sheet(
    'Maç detayı',
    (context) => Column(
      children: [
        Text(match.league, style: const TextStyle(color: AppColors.muted)),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _detailTeam(match.homeId, match.homeName)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                match.live ? '${match.homeScore} – ${match.awayScore}' : '–',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Expanded(child: _detailTeam(match.awayId, match.awayName)),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          match.live
              ? 'CANLI · ${match.clock}'
              : match.clock.replaceAll('\n', ' · '),
          style: const TextStyle(
            color: AppColors.lime,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (match.event.isNotEmpty) ...[
          const SizedBox(height: 20),
          SurfaceCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.timeline, color: AppColors.lime, size: 22),
                const SizedBox(width: 12),
                Expanded(child: Text(match.event)),
              ],
            ),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: () => _store.toggleMatch(match.id),
            icon: Icon(
              _store.isFavoriteMatch(match.id) ? Icons.star : Icons.star_border,
            ),
            label: Text(
              _store.isFavoriteMatch(match.id)
                  ? 'Favorilerden çıkar'
                  : 'Favorilere ekle',
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Örnek maç verisi · Canlı servise henüz bağlı değil',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    ),
  );

  Widget _detailTeam(String id, String name) => Column(
    children: [
      TeamBadge(id, size: 54),
      const SizedBox(height: 9),
      Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ],
  );

  void _openTeam(DemoTeam team) => _sheet(team.name, (context) {
    final fixtures = demoMatches
        .where((match) => match.homeId == team.id || match.awayId == team.id)
        .toList();
    return Column(
      children: [
        TeamBadge(team.id, size: 66),
        const SizedBox(height: 12),
        Text(
          '${team.league} · ${team.rank}. sırada',
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 18),
        FollowButton(
          followed: _store.follows(team.id),
          teamName: team.name,
          onTap: () => _store.toggleTeam(team.id),
        ),
        const SizedBox(height: 24),
        const SectionHeading('MAÇLAR'),
        if (fixtures.isEmpty)
          const Text(
            'Bu ön izlemede takımın maç kaydı bulunmuyor.',
            style: TextStyle(color: AppColors.muted),
          ),
        for (final match in fixtures)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              '${match.homeName} – ${match.awayName}',
              style: const TextStyle(fontSize: 13),
            ),
            subtitle: Text(
              match.live
                  ? '${match.homeScore} – ${match.awayScore} · ${match.clock}'
                  : match.clock.replaceAll('\n', ' · '),
            ),
            trailing: const Icon(Icons.chevron_right, color: AppColors.lime),
            onTap: () {
              Navigator.pop(context);
              _openMatch(match);
            },
          ),
        const SizedBox(height: 12),
        const Text(
          'Örnek takım bilgileri',
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  });

  void _openArticle(DemoArticle article) {
    _store.readArticle(article.id);
    _sheet(
      'Haber detayı',
      (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              NewsArtwork(article.teamId, size: 80),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.category.toUpperCase(),
                      style: const TextStyle(
                        color: AppColors.lime,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${article.source} · ${article.age}',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            article.title,
            style: const TextStyle(
              fontSize: 23,
              height: 1.2,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            article.summary,
            style: const TextStyle(color: Color(0xFFB7C0B9), height: 1.6),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tasarım için örnek içeriktir; güncel haber değildir. Yayıncı bağlantıları haber kaynağı bağlandığında eklenecek.',
            style: TextStyle(fontSize: 11, height: 1.5, color: AppColors.muted),
          ),
        ],
      ),
    );
  }

  void _openNotifications() {
    _store.clearNotifications();
    _sheet(
      'Bildirimler',
      (context) => Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.sports_soccer, color: AppColors.lime),
            title: const Text(
              'Galatasaray 2 – 1 Fenerbahçe',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
            subtitle: const Text('Gol geçerli sayıldı · 4 dk önce'),
            onTap: () {
              Navigator.pop(context);
              _openMatch(demoMatches.first);
            },
          ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.notifications_active_outlined,
              color: AppColors.lime,
            ),
            title: Text('Favorilerini takip et'),
            subtitle: Text(
              'Takımlar sekmesinden takip edeceğin kulüpleri seçebilirsin.',
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Örnek bildirimler · Push servisi henüz bağlı değil',
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _openProfile() => _sheet(
    'Profil',
    (context) => Column(
      children: [
        const ProfileAvatar(size: 72),
        const SizedBox(height: 14),
        const Text(
          'Kenan Yılmaz',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 6),
        const Text(
          'kenan@futbolix.app',
          style: TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 20),
        Text(
          '${_store.followedTeams.length} favori takım · ${_store.readCount} okunan haber',
          style: const TextStyle(color: AppColors.lime),
        ),
        const SizedBox(height: 20),
        const Text(
          'Bu, tasarımda kullanılan örnek profildir. Hesap girişi ve üyelik işlemleri henüz bağlı değildir.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, height: 1.5),
        ),
      ],
    ),
  );

  void _openSetting(String setting) {
    switch (setting) {
      case 'Bildirim ayarları':
        _sheet(
          setting,
          (context) => Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Gol bildirimleri'),
                value: _store.goalNotifications,
                onChanged: (value) => _store.updateNotifications(goals: value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Maç başlangıcı ve bitişi'),
                value: _store.matchNotifications,
                onChanged: (value) =>
                    _store.updateNotifications(matches: value),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Önemli haberler'),
                value: _store.newsNotifications,
                onChanged: (value) => _store.updateNotifications(news: value),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bu seçimler yalnız ön izleme oturumu boyunca saklanır.',
                style: TextStyle(color: AppColors.muted, fontSize: 12),
              ),
            ],
          ),
        );
      case 'Tema':
        _sheet(
          setting,
          (_) => const Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(Icons.dark_mode_outlined, color: AppColors.lime),
                title: Text('Koyu'),
                trailing: Icon(Icons.check_circle, color: AppColors.lime),
              ),
              SizedBox(height: 8),
              Text(
                'Bu tasarımın görünümü koyu tema olarak hazırlandı.',
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
        );
      case 'Dil':
        _sheet(
          setting,
          (_) => const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.language, color: AppColors.lime),
            title: Text('Türkçe'),
            trailing: Icon(Icons.check_circle, color: AppColors.lime),
          ),
        );
      case 'Puan durumu':
        final teams =
            demoTeams.where((team) => team.league == 'Süper Lig').toList()
              ..sort((a, b) => a.rank.compareTo(b.rank));
        _sheet(
          setting,
          (_) => Column(
            children: [
              const Text(
                'Süper Lig · Örnek sıralama',
                style: TextStyle(color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              for (final team in teams)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Text(
                    '${team.rank}',
                    style: const TextStyle(
                      color: AppColors.lime,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  title: Row(
                    children: [
                      TeamBadge(team.id, size: 25),
                      const SizedBox(width: 9),
                      Text(team.name, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ),
            ],
          ),
        );
      case 'Gizlilik':
        _sheet(
          setting,
          (_) => const Text(
            'Bu ön izlemede gerçek hesap veya canlı veri bağlantısı kullanılmıyor. Favoriler, aramalar ve bildirim tercihleri uygulama oturumu boyunca bellekte tutuluyor; sunucuya gönderilmiyor. Profil ve haber içerikleri tasarım örneğidir.',
            style: TextStyle(color: Color(0xFFB7C0B9), height: 1.7),
          ),
        );
    }
  }
}
