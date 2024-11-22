import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({super.key, required this.seed});

  final String seed;
  @override
  AvatarWidgetState createState() => AvatarWidgetState();
}

class AvatarWidgetState extends State<AvatarWidget> {
  ImageProvider? avatarImage;

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    CachedNetworkImageProvider response = CachedNetworkImageProvider(
        'https://api.dicebear.com/9.x/rings/png?seed=${widget.seed}');

    setState(() => avatarImage = response);
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: avatarImage,
      child: avatarImage == null ? CircularProgressIndicator() : null,
    );
  }
}
