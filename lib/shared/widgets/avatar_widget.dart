import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key, required this.seed, this.radius = 50});

  final String seed;
  final double radius;
  @override
  AvatarWidgetState createState() => AvatarWidgetState();
}

class AvatarWidgetState extends State<AvatarWidget> {
  ImageProvider? avatarImage;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadAvatar() async {
    CachedNetworkImageProvider response = CachedNetworkImageProvider(
        'https://api.dicebear.com/9.x/rings/png?seed=${widget.seed}');

    setState(() => avatarImage = response);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadAvatar(),
      builder: (context, snapshot) {
        return Skeletonizer(
          enabled: snapshot.connectionState == ConnectionState.waiting,
          child: CircleAvatar(
            radius: widget.radius,
            backgroundImage: avatarImage,
            child: avatarImage == null ? CircularProgressIndicator() : null,
          ),
        );
      },
    );
  }
}
