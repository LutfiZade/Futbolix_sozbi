import 'package:flutter/material.dart';

import '../../../app/demo_store.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/demo/demo_data.dart';
import '../../../shared/widgets/team_badge.dart';
import '../../../shared/widgets/ui_components.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key, required this.store, required this.onTeam});
  final DemoStore store;
  final ValueChanged<DemoTeam> onTeam;
  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = normalizedSearch(_search.text.trim());
    final teams = demoTeams
        .where(
          (team) => normalizedSearch(
            '${team.name} ${team.shortName} ${team.league} ${team.players}',
          ).contains(query),
        )
        .toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            key: const ValueKey('team-search'),
            controller: _search,
            onChanged: (_) => setState(() {}),
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Takım, lig veya oyuncu ara',
              prefixIcon: const Icon(
                Icons.search_rounded,
                size: 21,
                color: AppColors.muted,
              ),
              suffixIcon: _search.text.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Aramayı temizle',
                      onPressed: () => setState(_search.clear),
                      icon: const Icon(Icons.close, size: 18),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SectionHeading(
            query.isEmpty ? 'TAKİP ETTİKLERİM' : 'ARAMA SONUÇLARI',
            trailing: query.isEmpty ? null : '${teams.length} takım',
          ),
        ),
        Expanded(
          child: ListView(
            key: const PageStorageKey('teams-scroll'),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            children: [
              if (teams.isEmpty)
                const EmptyState('Aramana uygun takım bulunamadı.'),
              for (final team in teams)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SurfaceCard(
                    radius: 16,
                    highlight: widget.store.follows(team.id),
                    onTap: () => widget.onTeam(team),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        TeamBadge(team.id, size: 36),
                        const SizedBox(width: 11),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                team.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${team.league} · ${team.rank}. sırada',
                                style: const TextStyle(
                                  color: AppColors.muted,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        FollowButton(
                          followed: widget.store.follows(team.id),
                          teamName: team.name,
                          onTap: () => widget.store.toggleTeam(team.id),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class FollowButton extends StatelessWidget {
  const FollowButton({
    super.key,
    required this.followed,
    required this.teamName,
    required this.onTap,
  });
  final bool followed;
  final String teamName;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    label: followed ? '$teamName takibini bırak' : '$teamName takip et',
    button: true,
    toggled: followed,
    excludeSemantics: true,
    child: Material(
      color: followed ? const Color(0xFF143E29) : AppColors.elevated,
      shape: StadiumBorder(
        side: BorderSide(
          color: followed ? const Color(0xFF2C8758) : const Color(0xFF3A433F),
          width: .7,
        ),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
          child: Text(
            followed ? 'Takip ediliyor' : 'Takip et',
            style: TextStyle(
              color: followed ? AppColors.lime : const Color(0xFFABB2AE),
              fontWeight: FontWeight.w700,
              fontSize: 10.5,
            ),
          ),
        ),
      ),
    ),
  );
}
