import 'package:bloc_tutorial/auth/auth_error.dart';
import 'package:bloc_tutorial/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<void> showAuthErrorDialog({
  required AuthError autherror,
  required BuildContext context,
}) {
  return showGenericDialog(
    context: context,
    title: autherror.dialogTitle,
    content: autherror.dialogText,
    optionBuilder: () => {
      'OK': true,
    },
  );
}
