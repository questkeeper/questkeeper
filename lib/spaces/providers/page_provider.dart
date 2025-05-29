import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final pageControllerProvider = Provider<PageController>((ref) {
  final controller = PageController();
  ref.onDispose(() {
    controller.dispose();
  });
  return controller;
});

/// Provider to track the current page index
/// This avoids the issue of reading page property from PageController when multiple PageViews are attached
final currentPageProvider = StateProvider<int>((ref) => 0);
