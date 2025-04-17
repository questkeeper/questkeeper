import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FilledLoadingButton extends StatefulWidget {
  const FilledLoadingButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  final Widget child;
  final AsyncCallback onPressed;

  @override
  State<StatefulWidget> createState() {
    return _FilledLoadingButtonState();
  }
}

class _FilledLoadingButtonState extends State<FilledLoadingButton> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return FilledButton(
          onPressed: null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(width: 16),
              widget.child,
            ],
          ));
    } else {
      return FilledButton(
        onPressed: () async {
          setState(() {
            _loading = true;
          });

          await widget.onPressed();

          setState(() {
            _loading = false;
          });
        },
        child: widget.child,
      );
    }
  }
}
