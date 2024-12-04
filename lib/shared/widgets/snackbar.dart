import 'package:flutter_lucide/flutter_lucide.dart';
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
    return _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      description: callbackText != null ? Text(callbackText) : null,
      type: ToastificationType.success,
      backgroundColor: Colors.green,
      showProgressBar: true,
      icon: Icon(
          callback != null && callbackIcon != null
              ? callbackIcon.icon
              : LucideIcons.check,
          color: Colors.white),
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
    _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      type: ToastificationType.error,
      backgroundColor: Colors.red,
      showProgressBar: true,
      icon: Icon(LucideIcons.x, color: Colors.white),
      alignment: Alignment.bottomCenter,
    );
  }

  static void showInfoSnackbar(String message) {
    _toast.show(
      autoCloseDuration: const Duration(milliseconds: 3000),
      title: Text(message),
      type: ToastificationType.info,
      backgroundColor: primaryColor,
      showProgressBar: true,
      icon: Icon(LucideIcons.info, color: Colors.white),
      alignment: Alignment.bottomCenter,
    );
  }

  static void dismissToast(ToastificationItem toastItem) {
    _toast.dismiss(toastItem);
  }
}
