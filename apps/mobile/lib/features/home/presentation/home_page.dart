import 'package:flutter/material.dart';

import '../../../app/demo_store.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/demo/demo_data.dart';
import '../../../shared/widgets/team_badge.dart';
import '../../../shared/widgets/ui_components.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.store,
    required this.onTeams,
    required this.onMatches,
    required this.onMatch,
    required this.onBreakingNews,
  });
  final DemoStore store;
  final VoidCallback onTeams, onMatches, onBreakingNews;
  final ValueChanged<DemoMatch> onMatch;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Sport _sport = Sport.football;
  static const _sports = [
    (Sport.football, 'Futbol', '⚽'),
    (Sport.basketball, 'Basketbol', '🏀'),
    (Sport.volleyball, 'Voleybol', '🏐'),
    (Sport.tennis, 'Tenis', '🎾'),
  ];

  @override
  Widget build(BuildContext context) {
    final matches = demoMatches
        .where((match) => match.live && match.sport == _sport)
        .toList();
    final sportName = _sports.firstWhere((sport) => sport.$1 == _sport).$2;
    return ListView(
      key: const PageStorageKey('home-scroll'),
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SurfaceCard(
            radius: 21,
            highlight: true,
            onTap: widget.onBreakingNews,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [
                    Color(0xFF183D29),
                    Color(0xFF0D1712),
                    Color(0xFF101814),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Text(
                          'SON DAKİKA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '4 dk önce',
                        style: TextStyle(fontSize: 10, color: AppColors.muted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Derbide VAR kararı: Galatasaray'ın 2. golü uzun incelemenin ardından geçerli sayıldı",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                      height: 1.22,
                      letterSpacing: -.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Hakem Ozan Ergün, ofsayt incelemesinin ardından golü onayladı.',
                    style: TextStyle(
                      color: AppColors.muted,
                      fontSize: 12.5,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          height: 46,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _sports.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final (sport, label, emoji) = _sports[index];
              final selected = _sport == sport;
              final count = demoMatches
                  .where((match) => match.live && match.sport == sport)
                  .length;
              return Semantics(
                selected: selected,
                button: true,
                child: Material(
                  color: selected ? const Color(0xFF102C1E) : AppColors.surface,
                  shape: StadiumBorder(
                    side: BorderSide(
                      color: selected
                          ? const Color(0xFF24774D)
                          : AppColors.border,
                      width: .8,
                    ),
                  ),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => setState(() => _sport = sport),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      child: Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFF194C31)
                                  : AppColors.elevated,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              emoji,
                              style: const TextStyle(fontSize: 17),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: selected
                                  ? AppColors.text
                                  : AppColors.muted,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.green
                                  : AppColors.elevated,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: selected
                                    ? AppColors.background
                                    : AppColors.muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 17),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeading(
            'FAVORİLERİM',
            action: 'Düzenle',
            onAction: widget.onTeams,
          ),
        ),
        SizedBox(
          height: 74,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: widget.store.followedTeams.length + 1,
            separatorBuilder: (_, _) => const SizedBox(width: 17),
            itemBuilder: (context, index) {
              if (index == widget.store.followedTeams.length) {
                return InkWell(
                  onTap: widget.onTeams,
                  borderRadius: BorderRadius.circular(30),
                  child: SizedBox(
                    width: 54,
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.border,
                              width: 1.4,
                            ),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.muted,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Ekle',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final team = widget.store.followedTeams[index];
              return InkWell(
                onTap: widget.onTeams,
                borderRadius: BorderRadius.circular(30),
                child: SizedBox(
                  width: 55,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF278657),
                            width: 1.5,
                          ),
                        ),
                        child: TeamBadge(team.id, size: 45),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        team.shortName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFFB6BDB9),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeading(
            'CANLI · ${sportName.toUpperCase()}',
            live: true,
            action: 'Tümü',
            onAction: widget.onMatches,
          ),
        ),
        ...matches.map(
          (match) => Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: _HomeMatchCard(match, onTap: () => widget.onMatch(match)),
          ),
        ),
      ],
    );
  }
}

class _HomeMatchCard extends StatelessWidget {
  const _HomeMatchCard(this.match, {required this.onTap});
  final DemoMatch match;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    onTap: onTap,
    padding: const EdgeInsets.all(14),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.red.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.red.withValues(alpha: .35),
                  width: .6,
                ),
              ),
              child: const Text(
                '• CANLI',
                style: TextStyle(
                  color: Color(0xFFFF787C),
                  fontSize: 9,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                match.league,
                style: const TextStyle(color: AppColors.muted, fontSize: 10),
              ),
            ),
            Text(
              match.clock,
              style: const TextStyle(
                color: AppColors.lime,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        _team(match.homeId, match.homeName, match.homeScore),
        const SizedBox(height: 7),
        _team(match.awayId, match.awayName, match.awayScore),
        const Padding(
          padding: EdgeInsets.only(top: 11, bottom: 10),
          child: Divider(height: 1, thickness: .5),
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                match.event,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10.5, color: AppColors.muted),
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'Detay ›',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _team(String id, String name, int score) => Row(
    children: [
      TeamBadge(id, size: 26),
      const SizedBox(width: 9),
      Expanded(
        child: Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      Text(
        '$score',
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
      ),
    ],
  );
}
