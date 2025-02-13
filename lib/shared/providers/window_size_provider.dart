import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class WindowSize {
  final double width;
  final double height;
  final bool isMobile;
  final bool isCompact;

  const WindowSize({
    required this.width,
    required this.height,
    required this.isMobile,
    required this.isCompact,
  });

  WindowSize copyWith({
    double? width,
    double? height,
    bool? isMobile,
    bool? isCompact,
  }) {
    return WindowSize(
      width: width ?? this.width,
      height: height ?? this.height,
      isMobile: isMobile ?? this.isMobile,
      isCompact: isCompact ?? this.isCompact,
    );
  }
}

class WindowSizeNotifier extends StateNotifier<WindowSize> {
  WindowSizeNotifier()
      : super(const WindowSize(
          width: 0,
          height: 0,
          isMobile: false,
          isCompact: false,
        ));

  void setSize(Size size) {
    state = WindowSize(
      width: size.width,
      height: size.height,
      isMobile: size.width < 800,
      isCompact: size.width < 1200,
    );
  }
}

final windowSizeProvider =
    StateNotifierProvider<WindowSizeNotifier, WindowSize>((ref) {
  return WindowSizeNotifier();
});

// Convenience providers
final isMobileProvider = Provider<bool>((ref) {
  return ref.watch(windowSizeProvider).isMobile;
});

final isCompactProvider = Provider<bool>((ref) {
  return ref.watch(windowSizeProvider).isCompact;
});
