import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_theme.dart';

/// Uses small logo/avatar regions from the supplied references in this preview.
/// The screens themselves are Flutter widgets, never screenshot backgrounds.
class ReferenceCrop extends StatelessWidget {
  const ReferenceCrop({
    super.key,
    required this.asset,
    required this.source,
    required this.size,
    this.circular = true,
  });
  final String asset;
  final Rect source;
  final double size;
  final bool circular;
  static final Map<String, Future<ui.Image>> _images = {};

  static Future<ui.Image> _load(String asset) =>
      _images.putIfAbsent(asset, () async {
        final data = await rootBundle.load(asset);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        codec.dispose();
        return frame.image;
      });

  @override
  Widget build(BuildContext context) {
    final child = SizedBox.square(
      dimension: size,
      child: FutureBuilder<ui.Image>(
        future: _load(asset),
        builder: (context, snapshot) => snapshot.hasData
            ? CustomPaint(painter: _CropPainter(snapshot.data!, source))
            : const ColoredBox(color: AppColors.elevated),
      ),
    );
    return ExcludeSemantics(
      child: circular
          ? ClipOval(child: child)
          : ClipRRect(borderRadius: BorderRadius.circular(12), child: child),
    );
  }
}

class _CropPainter extends CustomPainter {
  const _CropPainter(this.image, this.source);
  final ui.Image image;
  final Rect source;
  @override
  void paint(Canvas canvas, Size size) => canvas.drawImageRect(
    image,
    source,
    Offset.zero & size,
    Paint()..filterQuality = FilterQuality.high,
  );
  @override
  bool shouldRepaint(_CropPainter oldDelegate) =>
      image != oldDelegate.image || source != oldDelegate.source;
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, this.size = 34});
  final double size;
  @override
  Widget build(BuildContext context) => ReferenceCrop(
    asset: 'assets/reference/home.jpeg',
    source: const Rect.fromLTWH(91, 134, 61, 61),
    size: size,
  );
}

class TeamBadge extends StatelessWidget {
  const TeamBadge(this.id, {super.key, this.size = 36});
  final String id;
  final double size;
  @override
  Widget build(BuildContext context) {
    final rect = switch (id) {
      'gs' => const Rect.fromLTWH(65, 297, 51, 51),
      'fb' => const Rect.fromLTWH(65, 390, 51, 51),
      'bjk' => const Rect.fromLTWH(65, 484, 51, 51),
      'ts' => const Rect.fromLTWH(65, 578, 51, 51),
      'basak' => const Rect.fromLTWH(65, 672, 51, 51),
      'samsun' => const Rect.fromLTWH(65, 766, 51, 51),
      _ => null,
    };
    if (rect != null) {
      return ReferenceCrop(
        asset: 'assets/reference/teams.jpeg',
        source: rect,
        size: size,
      );
    }
    if (id == 'city') {
      return ReferenceCrop(
        asset: 'assets/reference/home.jpeg',
        source: const Rect.fromLTWH(300, 594, 67, 67),
        size: size,
      );
    }
    if (id == 'arsenal') {
      return ReferenceCrop(
        asset: 'assets/reference/matches.jpeg',
        source: const Rect.fromLTWH(149, 617, 25, 25),
        size: size,
      );
    }
    if (id == 'real') {
      return ReferenceCrop(
        asset: 'assets/reference/news.jpeg',
        source: const Rect.fromLTWH(81, 815, 58, 65),
        size: size,
      );
    }
    final (label, color) = switch (id) {
      'efes' => ('EFS', const Color(0xFF1359A2)),
      'pao' => ('PAO', const Color(0xFF14704A)),
      'vakif' => ('VAK', const Color(0xFF13804A)),
      'gsv' => ('GSV', const Color(0xFFBB5518)),
      'sinner' => ('SIN', const Color(0xFF9F4F0D)),
      'alcaraz' => ('ALC', const Color(0xFF643AB0)),
      'konya' => ('KON', const Color(0xFF117746)),
      'rize' => ('RİZ', const Color(0xFF156A9C)),
      'goztepe' => ('GÖZ', const Color(0xFFAC2527)),
      'turkiye' => ('★', const Color(0xFFC82735)),
      _ => ('FX', AppColors.elevated),
    };
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * .29,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
