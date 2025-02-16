import 'package:flutter/services.dart';

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.toLowerCase().replaceAll(" ", "_");

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end,
      ),
    );
  }
}

class AlphaNumericTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: newValue.selection.end,
      ),
    );
  }
}
