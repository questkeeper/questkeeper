import 'package:questkeeper/constants.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class SnackbarService {
  static final Toastification _toast = Toastification();

  static ToastificationItem showSuccessSnackbar(
    String message, {
    Function? callback,
    Icon? callbackIcon,
    String? callbackText,
  }) {
    debugPrint("Showing success snackbar: $message");
    return _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      description: callbackText != null ? Text(callbackText) : null,
      type: ToastificationType.success,
      backgroundColor: Colors.green,
      showProgressBar: true,
      icon: callbackIcon,
      showIcon: callbackIcon != null,
      alignment: Alignment.bottomCenter,
      style: ToastificationStyle.flatColored,
      callbacks: ToastificationCallbacks(
        onTap: (_) {
          if (callback != null) {
            callback();
          }
        },
      ),
    );
  }

  static void showErrorSnackbar(String message) {
    debugPrint("Showing error snackback: $message");
    _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      type: ToastificationType.error,
      backgroundColor: Colors.red,
      showProgressBar: true,
      icon: null,
      showIcon: false,
      alignment: Alignment.bottomCenter,
    );
  }

  static void showInfoSnackbar(String message) {
    debugPrint("Showing info snackbar: $message");
    _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      type: ToastificationType.info,
      backgroundColor: primaryColor,
      showProgressBar: true,
      showIcon: false,
      alignment: Alignment.bottomCenter,
    );
  }

  static void dismissToast(ToastificationItem toastItem) {
    debugPrint("Dismissing toast");
    _toast.dismiss(toastItem);
  }
}
