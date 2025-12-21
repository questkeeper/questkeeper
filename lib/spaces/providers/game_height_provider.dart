import 'package:flutter_riverpod/flutter_riverpod.dart';

final gameHeightProvider =
    NotifierProvider<GameHeightNotifier, double>(GameHeightNotifier.new);

class GameHeightNotifier extends Notifier<double> {
  @override
  double build() => 1.0;

  void setHeight(double height) {
    state = height;
  }
}
