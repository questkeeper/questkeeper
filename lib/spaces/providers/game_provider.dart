import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';

final gameProvider =
    NotifierProvider<GameNotifier, FamiliarsWidgetGame?>(GameNotifier.new);

class GameNotifier extends Notifier<FamiliarsWidgetGame?> {
  @override
  FamiliarsWidgetGame? build() => null;

  void setGame(FamiliarsWidgetGame? game) {
    state = game;
  }
}
