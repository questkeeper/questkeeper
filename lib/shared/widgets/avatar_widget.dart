import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key, required this.seed, this.radius = 50});

  final String seed;
  final double radius;

  @override
  AvatarWidgetState createState() => AvatarWidgetState();
}

class AvatarWidgetState extends State<AvatarWidget> {
  String? svgString;
  DefaultCacheManager cacheManager = DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final file = await cacheManager.getSingleFile(
        'https://api.dicebear.com/9.x/rings/svg?seed=${widget.seed}',
      );

      if (!mounted) return;

      final content = await file.readAsString();
      setState(() => svgString = content);
    } catch (e) {
      debugPrint('Error loading avatar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: svgString == null,
      child: Container(
        width: widget.radius * 2,
        height: widget.radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        child: ClipOval(
          child: svgString == null
              ? Center(child: CircularProgressIndicator())
              : SvgPicture.string(
                  svgString!,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
