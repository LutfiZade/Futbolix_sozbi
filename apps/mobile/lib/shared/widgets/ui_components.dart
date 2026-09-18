import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';
import 'team_badge.dart';

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.highlight = false,
    this.onTap,
    this.radius = 18,
  });
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool highlight;
  final VoidCallback? onTap;
  final double radius;
  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: BorderSide(
        color: highlight ? const Color(0xFF28513B) : AppColors.border,
        width: .7,
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    this.title,
    this.greeting = false,
    required this.onNotifications,
    required this.onProfile,
    this.unread = true,
  });
  final String? title;
  final bool greeting, unread;
  final VoidCallback onNotifications, onProfile;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 14, 16, 17),
    child: Row(
      children: [
        if (greeting) ...[
          InkWell(
            onTap: onProfile,
            borderRadius: BorderRadius.circular(24),
            child: const ProfileAvatar(size: 44),
          ),
          const SizedBox(width: 10),
        ],
        Expanded(
          child: greeting
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'İyi günler,',
                      style: TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Kenan Yılmaz',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(fontSize: 20),
                    ),
                  ],
                )
              : Text(
                  title ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
        ),
        Semantics(
          label: 'Bildirimler',
          button: true,
          child: SizedBox.square(
            dimension: 36,
            child: SurfaceCard(
              radius: 13,
              onTap: onNotifications,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 21),
                  if (unread)
                    Positioned(
                      top: 7,
                      right: 8,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        if (!greeting) ...[
          const SizedBox(width: 11),
          Semantics(
            label: 'Profil',
            button: true,
            child: InkWell(
              onTap: onProfile,
              borderRadius: BorderRadius.circular(24),
              child: const ProfileAvatar(size: 34),
            ),
          ),
        ],
      ],
    ),
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(
    this.title, {
    super.key,
    this.action,
    this.onAction,
    this.live = false,
    this.trailing,
  });
  final String title;
  final String? action, trailing;
  final VoidCallback? onAction;
  final bool live;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        if (live) ...[
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              letterSpacing: 1.25,
              color: AppColors.muted,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: const TextStyle(color: AppColors.muted, fontSize: 10),
          ),
        if (action != null)
          InkWell(
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                action!,
                style: const TextStyle(
                  color: AppColors.lime,
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class FilterPill extends StatelessWidget {
  const FilterPill(
    this.label, {
    super.key,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    selected: selected,
    button: true,
    child: Material(
      color: selected ? AppColors.green : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          color: selected ? AppColors.green : AppColors.border,
          width: .7,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.background : AppColors.muted,
            ),
          ),
        ),
      ),
    ),
  );
}

class EmptyState extends StatelessWidget {
  const EmptyState(
    this.message, {
    super.key,
    this.icon = Icons.search_off_rounded,
  });
  final String message;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 44, horizontal: 20),
    child: Column(
      children: [
        Icon(icon, color: AppColors.muted, size: 36),
        const SizedBox(height: 14),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    ),
  );
}
