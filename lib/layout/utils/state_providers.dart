import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navRailExpandedProvider = NotifierProvider<NavRailExpandedNotifier, bool>(
    NavRailExpandedNotifier.new);
final zenModeProvider =
    NotifierProvider<ZenModeNotifier, bool>(ZenModeNotifier.new);
final commandPaletteVisibleProvider =
    NotifierProvider<CommandPaletteVisibleNotifier, bool>(
        CommandPaletteVisibleNotifier.new);
final contextPaneProvider =
    NotifierProvider<ContextPaneNotifier, Widget?>(ContextPaneNotifier.new);
final isContextPaneCollapsedProvider =
    NotifierProvider<IsContextPaneCollapsedNotifier, bool>(
        IsContextPaneCollapsedNotifier.new);

class ContextPaneNotifier extends Notifier<Widget?> {
  @override
  Widget? build() => null;

  void set(Widget? value) {
    state = value;
  }
}

class IsContextPaneCollapsedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }
}

class NavRailExpandedNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

class ZenModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}

class CommandPaletteVisibleNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) {
    state = value;
  }

  void toggle() {
    state = !state;
  }
}
