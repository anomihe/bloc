import 'package:bloc_tutorial/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Delete account',
    content:
        'Are you sure you want to delete your account? you cannot undo this operation!',
    optionBuilder: () => {
      'Cancel': false,
      'Delete account': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
