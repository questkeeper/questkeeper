import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:questkeeper/familiars/widgets/familiars_widget_game.dart';

/// Manages the lifecycle and ownership of the game instance to prevent multiple widgets
/// from attaching to the same game instance simultaneously.
class GameManager {
  FamiliarsWidgetGame? _gameInstance;
  String? _currentOwner;

  /// Returns the current game instance.
  FamiliarsWidgetGame? get gameInstance => _gameInstance;

  /// Checks if the requester can attach to the game instance.
  bool canAttach(String requesterId) {
    // Allow attachment if there's no current owner or if the requester is the current owner
    return _currentOwner == null || _currentOwner == requesterId;
  }

  /// Gets the game instance if the requester has permission.
  FamiliarsWidgetGame? getGameInstance(String requesterId) {
    if (canAttach(requesterId)) {
      _currentOwner = requesterId;
      return _gameInstance;
    }
    return null;
  }

  /// Sets the game instance and assigns ownership to the specified owner.
  void setGameInstance(FamiliarsWidgetGame? game, String ownerId) {
    if (_currentOwner != null && _currentOwner != ownerId) {
      debugPrint('Warning: Changing game ownership from $_currentOwner to $ownerId');
    }
    
    _gameInstance = game;
    _currentOwner = game != null ? ownerId : null;
  }

  /// Releases ownership of the game instance if the current owner matches.
  void releaseOwnership(String ownerId) {
    if (_currentOwner == ownerId) {
      _currentOwner = null;
    }
  }
}

/// Provider for accessing the GameManager instance.
final gameManagerProvider = Provider<GameManager>((ref) => GameManager());

/// Provider for accessing the current game instance.
final gameProvider = Provider<FamiliarsWidgetGame?>((ref) {
  return ref.watch(gameManagerProvider).gameInstance;
});
