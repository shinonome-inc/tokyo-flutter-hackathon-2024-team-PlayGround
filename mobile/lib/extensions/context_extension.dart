import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  /// AlertDialogを表示する。
  Future<void> showAlertDialog({required Widget dialog}) async {
    return await showDialog(
      context: this,
      builder: (context) => dialog,
    );
  }
}
