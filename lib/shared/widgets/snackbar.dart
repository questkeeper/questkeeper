import 'package:assigngo_rewrite/constants.dart';
import 'package:flutter/material.dart';

class SnackbarService {
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBarFormat(context, message, Colors.green),
    );
  }

  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBarFormat(context, message, Colors.red),
    );
  }

  static void showInfoSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      _snackBarFormat(context, message, primaryColor),
    );
  }

  static SnackBar _snackBarFormat(
      BuildContext context, String message, Color color) {
    return SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 3),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
