import 'package:flutter/material.dart';

import '../../../app/demo_store.dart';
import '../../../app/theme/app_theme.dart';
import '../../../shared/widgets/team_badge.dart';
import '../../../shared/widgets/ui_components.dart';

class MorePage extends StatelessWidget {
  const MorePage({
    super.key,
    required this.store,
    required this.onTeams,
    required this.onMatches,
    required this.onNews,
    required this.onProfile,
    required this.onSetting,
  });
  final DemoStore store;
  final VoidCallback onTeams, onMatches, onNews, onProfile;
  final ValueChanged<String> onSetting;
  @override
  Widget build(BuildContext context) => ListView(
    key: const PageStorageKey('more-scroll'),
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
    children: [
      SurfaceCard(
        highlight: true,
        radius: 21,
        onTap: onProfile,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF103421), Color(0xFF101917)],
            ),
          ),
          child: Row(
            children: [
              const ProfileAvatar(size: 54),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kenan Yılmaz',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -.4,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'kenan@futbolix.app · Pro üye',
                      style: TextStyle(fontSize: 11, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: const ShapeDecoration(
                  color: AppColors.green,
                  shape: StadiumBorder(),
                ),
                child: const Text(
                  'PRO',
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      Row(
        children: [
          Expanded(child: _Stat('128', 'Takip edilen maç', onMatches)),
          const SizedBox(width: 9),
          Expanded(
            child: _Stat(
              '${store.followedTeams.length}',
              'Favori takım',
              onTeams,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(child: _Stat('${store.readCount}', 'Okunan haber', onNews)),
        ],
      ),
      const SizedBox(height: 18),
      const SectionHeading('FAVORİ TAKIMLARIM'),
      if (store.followedTeams.isEmpty)
        InkWell(
          onTap: onTeams,
          child: const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'İlk favori takımını ekle +',
              style: TextStyle(color: AppColors.lime),
            ),
          ),
        ),
      if (store.followedTeams.isNotEmpty)
        SizedBox(
          height: 39,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: store.followedTeams.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final team = store.followedTeams[index];
              return SurfaceCard(
                highlight: true,
                radius: 30,
                onTap: onTeams,
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                child: Row(
                  children: [
                    TeamBadge(team.id, size: 25),
                    const SizedBox(width: 7),
                    Text(
                      team.shortName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      const SizedBox(height: 16),
      SurfaceCard(
        radius: 19,
        child: Column(
          children: [
            _SettingsRow(
              '⭐',
              'Favori takımlar',
              '${store.followedTeams.length} takım',
              onTeams,
            ),
            _divider,
            _SettingsRow(
              '🔔',
              'Bildirim ayarları',
              store.goalNotifications ||
                      store.matchNotifications ||
                      store.newsNotifications
                  ? 'Açık'
                  : 'Kapalı',
              () => onSetting('Bildirim ayarları'),
            ),
            _divider,
            _SettingsRow('🎨', 'Tema', 'Koyu', () => onSetting('Tema')),
            _divider,
            _SettingsRow('🌐', 'Dil', 'Türkçe', () => onSetting('Dil')),
            _divider,
            _SettingsRow(
              '📊',
              'Puan durumu',
              'Süper Lig',
              () => onSetting('Puan durumu'),
            ),
            _divider,
            _SettingsRow('🔒', 'Gizlilik', '', () => onSetting('Gizlilik')),
          ],
        ),
      ),
      const SizedBox(height: 18),
      const Text(
        'Futbolix · Ön izleme · Örnek veriler',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, color: Color(0xFF56615B)),
      ),
    ],
  );

  static const _divider = Divider(
    height: 1,
    thickness: .45,
    color: AppColors.border,
  );
}

class _Stat extends StatelessWidget {
  const _Stat(this.value, this.label, this.onTap);
  final String value, label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    onTap: onTap,
    radius: 17,
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 23,
            height: 1.1,
            fontWeight: FontWeight.w900,
            color: AppColors.lime,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: AppColors.muted),
        ),
      ],
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow(this.emoji, this.label, this.value, this.onTap);
  final String emoji, label, value;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.elevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 17)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 11, color: AppColors.muted),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.chevron_right_rounded,
            size: 17,
            color: AppColors.muted,
          ),
        ],
      ),
    ),
  );
}
