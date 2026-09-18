import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/demo/demo_data.dart';
import '../../../shared/widgets/team_badge.dart';
import '../../../shared/widgets/ui_components.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key, required this.onArticle});
  final ValueChanged<DemoArticle> onArticle;
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  String _category = 'Tümü';
  static const _categories = [
    'Tümü',
    'Süper Lig',
    'Transfer',
    'Avrupa',
    'Milli Takım',
  ];
  @override
  Widget build(BuildContext context) {
    final articles = demoArticles
        .where(
          (article) => _category == 'Tümü' || article.category == _category,
        )
        .toList();
    return Column(
      children: [
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 7),
            itemBuilder: (_, index) => FilterPill(
              _categories[index],
              selected: _category == _categories[index],
              onTap: () => setState(() => _category = _categories[index]),
            ),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView(
            key: const PageStorageKey('news-scroll'),
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              SizedBox(
                height: 163,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: articles.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 12),
                  itemBuilder: (_, index) => SizedBox(
                    width: MediaQuery.sizeOf(context).width * .72,
                    child: _FeaturedArticle(
                      articles[index],
                      onTap: () => widget.onArticle(articles[index]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              for (final article in articles)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 9),
                  child: SurfaceCard(
                    radius: 18,
                    onTap: () => widget.onArticle(article),
                    padding: const EdgeInsets.all(11),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NewsArtwork(article.teamId, size: 73),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                article.category.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: .8,
                                  color: AppColors.lime,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                article.title,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.32,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${article.source} · ${article.age}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
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

List<Color> newsColors(String teamId) => switch (teamId) {
  'gs' => [
    const Color(0xFF725015),
    const Color(0xFF9D1733),
    const Color(0xFF29101C),
  ],
  'fb' => [
    const Color(0xFF555324),
    const Color(0xFF183B48),
    const Color(0xFF0E161B),
  ],
  'real' => [
    const Color(0xFF495564),
    const Color(0xFF273A64),
    const Color(0xFF111D2E),
  ],
  'turkiye' => [
    const Color(0xFF96152E),
    const Color(0xFF582131),
    const Color(0xFF151E21),
  ],
  _ => [
    const Color(0xFF4C2645),
    const Color(0xFF255A8F),
    const Color(0xFF101A21),
  ],
};

class NewsArtwork extends StatelessWidget {
  const NewsArtwork(this.teamId, {super.key, this.size = 73});
  final String teamId;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size * .91,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: newsColors(teamId),
      ),
      border: Border.all(color: const Color(0xFF39443D), width: .5),
    ),
    child: TeamBadge(teamId, size: size * .61),
  );
}

class _FeaturedArticle extends StatelessWidget {
  const _FeaturedArticle(this.article, {required this.onTap});
  final DemoArticle article;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SurfaceCard(
    radius: 21,
    onTap: onTap,
    child: Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: newsColors(article.teamId),
              ),
            ),
          ),
        ),
        Positioned(
          top: 13,
          right: 9,
          child: Opacity(
            opacity: .5,
            child: TeamBadge(article.teamId, size: 96),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  AppColors.surface,
                  AppColors.surface,
                ],
                stops: [0, .78, 1],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  article.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 9,
                    letterSpacing: .8,
                    fontWeight: FontWeight.w900,
                    color: AppColors.background,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                article.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1.19,
                  letterSpacing: -.2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${article.source}  •  ${article.age}',
                style: const TextStyle(fontSize: 10, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
