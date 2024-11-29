import 'package:flutter/material.dart';

enum TrophyType { gold, silver, bronze }

class TrophyAvatar extends StatelessWidget {
  const TrophyAvatar(
      {super.key, this.trophyType = TrophyType.bronze, this.radius = 50});

  final TrophyType trophyType;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: Image.asset(
        'assets/trophy/trophy_${trophyType.toString().split('.').last}.png',
        width: 32,
        height: 32,
      ),
    );
  }
}
