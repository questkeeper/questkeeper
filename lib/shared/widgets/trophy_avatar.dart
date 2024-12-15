import 'package:flutter/material.dart';

enum TrophyType { gold, silver, bronze }

class TrophyAvatar extends StatelessWidget {
  const TrophyAvatar(
      {super.key, this.trophyType = TrophyType.bronze, this.scale = 1});

  final TrophyType trophyType;
  final double scale;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      child: Image.asset(
        'assets/trophy/trophy_${trophyType.toString().split('.').last}.png',
        width: 32,
        height: 32,
        scale: scale,
      ),
    );
  }
}
