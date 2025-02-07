import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navRailExpandedProvider = StateProvider<bool>((ref) => false);
final zenModeProvider = StateProvider<bool>((ref) => false);
final commandPaletteVisibleProvider = StateProvider<bool>((ref) => false);
final contextPaneProvider = StateProvider<Widget?>((ref) => null);
