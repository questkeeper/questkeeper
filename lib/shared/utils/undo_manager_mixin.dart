import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:questkeeper/shared/widgets/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toastification/toastification.dart';

enum ActionTiming { immediate, afterUndoPeriod }

class UndoAction<T> {
  final T previousState;
  final T newState;
  final Future<void> Function() repositoryAction;
  final String successMessage;
  final String undoMessage;
  final ActionTiming timing;
  final Duration undoPeriod;
  final Future<void> Function() postUndoAction;

  UndoAction({
    required this.previousState,
    required this.newState,
    required this.repositoryAction,
    required this.successMessage,
    this.undoMessage = "Tap to undo",
    this.timing = ActionTiming.immediate,
    this.undoPeriod = const Duration(seconds: 5),
    this.postUndoAction = _defaultPostUndoAction,
  });

  static Future<void> _defaultPostUndoAction() async {}
}

mixin UndoManagerMixin<T> on AutoDisposeAsyncNotifier<T> {
  final Map<String, Timer> _pendingActions = {};

  void performActionWithUndo(UndoAction<T> action) {
    final oldState = state.value;
    if (oldState == null) return;

    final actionId = DateTime.now().microsecondsSinceEpoch.toString();
    state = AsyncValue.data(action.newState);

    ToastificationItem? toastItem;

    void undoCallback() {
      state = AsyncValue.data(action.previousState);
      if (toastItem != null) {
        SnackbarService.dismissToast(toastItem);
      }

      if (_pendingActions.containsKey(actionId)) {
        _pendingActions[actionId]?.cancel();
        _pendingActions.remove(actionId);
      }

      action.postUndoAction();

      SnackbarService.showSuccessSnackbar("Action undone");
    }

    toastItem = SnackbarService.showSuccessSnackbar(
      action.successMessage,
      callback: undoCallback,
      callbackIcon: const Icon(LucideIcons.undo_2),
      callbackText: action.undoMessage,
    );

    if (action.timing == ActionTiming.afterUndoPeriod) {
      final timer = Timer(action.undoPeriod, () {
        action.repositoryAction().catchError((error) {
          state = AsyncValue.data(oldState);
          SnackbarService.showErrorSnackbar("Failed to perform action");
        });
        _pendingActions.remove(actionId);
      });
      _pendingActions[actionId] = timer;
    } else {
      action.repositoryAction().catchError((error) {
        state = AsyncValue.data(oldState);
        SnackbarService.showErrorSnackbar("Failed to perform action");
      });
    }
  }
}
