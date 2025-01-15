import 'package:flutter/material.dart';

/// Show a drawer from the left or right side of the screen
/// with a custom child widget.
///
/// [context] is the current context.
/// [child] is the widget to be shown in the drawer.
/// [key] is the key for the Dismissible widget.
/// [widthOffsetLeftLean] is whether the drawer should be shown from the left or right side.
/// [isDismissible] is whether the drawer can be dismissed by swiping.
///
/// [child] can generally be a SingleChildScrollView or a Column widget.
///
/// Used for the task creation/edit, settings, and friend search
void showDrawer({
  required BuildContext context,
  required Widget child,
  required String key,
  bool widthOffsetLeftLean = true,
  bool isDismissible = true,
}) {
  final deviceWidth = MediaQuery.of(context).size.width;
  bool isPopping = false;

  Navigator.of(context).push(
    PageRouteBuilder(
      opaque: false,
      barrierColor: Colors.black54,
      barrierDismissible: isDismissible,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(widthOffsetLeftLean ? 1.0 : -1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastEaseInToSlowEaseOut,
            )),
            child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTapDown: (details) {
            final tapPosition = details.globalPosition.dx;
            if (widthOffsetLeftLean) {
              // For right drawer, dismiss if tap is on left side
              if (tapPosition < deviceWidth * 0.2) {
                Navigator.of(context).pop();
              }
            } else {
              // For left drawer, dismiss if tap is on right side
              if (tapPosition > deviceWidth * 0.8) {
                Navigator.of(context).pop();
              }
            }
          },
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(widthOffsetLeftLean ? 1.0 : -1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.fastEaseInToSlowEaseOut,
            )),
            child: Dismissible(
              key: Key(key),
              confirmDismiss: (_) async {
                if (!isPopping && context.mounted) {
                  isPopping = false;
                  await Navigator.of(context).maybePop(true);
                  isPopping = false;
                }
                return true;
              },
              child: Padding(
                padding: EdgeInsets.only(
                  left: deviceWidth * (widthOffsetLeftLean ? 0.13 : 0.02),
                  right: deviceWidth * (widthOffsetLeftLean ? 0.02 : 0.13),
                ),
                child: SafeArea(
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(-2, 0),
                          ),
                        ],
                      ),
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
