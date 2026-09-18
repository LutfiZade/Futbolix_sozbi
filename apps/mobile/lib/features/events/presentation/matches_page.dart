import 'package:flutter/material.dart';

import '../../../app/demo_store.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/demo/demo_data.dart';
import '../../../shared/widgets/team_badge.dart';
import '../../../shared/widgets/ui_components.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key, required this.store, required this.onMatch});
  final DemoStore store;
  final ValueChanged<DemoMatch> onMatch;
  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  String _mode = 'Canlı';
  String _league = 'Tümü';
  static const leagues = [
    'Tümü',
    'Süper Lig',
    'Premier Lig',
    'La Liga',
    'Şampiyonlar Ligi',
    'EuroLeague',
    'Sultanlar Ligi',
    'ATP Finals',
  ];
  @override
  Widget build(BuildContext context) {
    final matches = demoMatches
        .where(
          (match) =>
              (_mode != 'Canlı' || match.live) &&
              (_mode != 'Favoriler' ||
                  widget.store.isFavoriteMatch(match.id)) &&
              (_league == 'Tümü' || match.league == _league),
        )
        .toList();
    final groups = matches.map((match) => match.league).toSet();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              for (final mode in ['Canlı', 'Tümü', 'Favoriler']) ...[
                if (mode != 'Canlı') const SizedBox(width: 8),
                Expanded(
                  child: Semantics(
                    selected: _mode == mode,
                    button: true,
                    child: Material(
                      color: _mode == mode
                          ? const Color(0xFF103523)
                          : AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: _mode == mode
                              ? const Color(0xFF287C4E)
                              : AppColors.border,
                          width: .7,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _mode = mode),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          child: Text(
                            mode,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: _mode == mode
                                  ? AppColors.lime
                                  : AppColors.muted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: leagues.length,
            separatorBuilder: (_, _) => const SizedBox(width: 7),
            itemBuilder: (_, index) => FilterPill(
              leagues[index],
              selected: _league == leagues[index],
              onTap: () => setState(() => _league = leagues[index]),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            key: const PageStorageKey('matches-scroll'),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (matches.isEmpty)
                const EmptyState(
                  'Bu filtrede maç bulunmuyor.\nBaşka bir lig veya görünüm seçebilirsin.',
                ),
              for (final league in groups) ...[
                Row(
                  children: [
                    Text(
                      league,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(child: Divider(thickness: .5)),
                    const SizedBox(width: 8),
                    Text(
                      '${matches.where((match) => match.league == league).length} maç',
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                for (final match in matches.where(
                  (match) => match.league == league,
                ))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _CompactMatchCard(
                      match: match,
                      favorite: widget.store.isFavoriteMatch(match.id),
                      onFavorite: () => widget.store.toggleMatch(match.id),
                      onTap: () => widget.onMatch(match),
                    ),
                  ),
                const SizedBox(height: 9),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CompactMatchCard extends StatelessWidget {
  const _CompactMatchCard({
    required this.match,
    required this.favorite,
    required this.onFavorite,
    required this.onTap,
  });
  final DemoMatch match;
  final bool favorite;
  final VoidCallback onFavorite, onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    highlight: match.live,
    radius: 16,
    onTap: onTap,
    padding: const EdgeInsets.fromLTRB(9, 11, 6, 11),
    child: Row(
      children: [
        SizedBox(
          width: 51,
          child: Column(
            children: [
              Text(
                match.clock,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: match.live ? AppColors.lime : AppColors.muted,
                ),
              ),
              if (match.live) ...[
                const SizedBox(height: 4),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B3035),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
        Container(width: .6, height: 30, color: AppColors.border),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            children: [
              _team(match.homeId, match.homeName, match.homeScore),
              const SizedBox(height: 6),
              _team(match.awayId, match.awayName, match.awayScore),
            ],
          ),
        ),
        SizedBox(
          width: 31,
          child: IconButton(
            padding: EdgeInsets.zero,
            tooltip: favorite
                ? 'Maçı favorilerden çıkar'
                : 'Maçı favorilere ekle',
            onPressed: onFavorite,
            icon: Icon(
              favorite ? Icons.star_rounded : Icons.star_border_rounded,
              size: 20,
              color: favorite ? AppColors.lime : AppColors.muted,
            ),
          ),
        ),
      ],
    ),
  );
  Widget _team(String id, String name, int score) => Row(
    children: [
      TeamBadge(id, size: 19),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(width: 3),
      Text(
        match.live ? '$score' : '–',
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
      ),
    ],
  );
}
