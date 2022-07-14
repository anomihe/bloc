import 'package:bloc_tutorial/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart' show BuildContext;

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to Log Out!',
    optionBuilder: () => {
      'Cancel': false,
      'Log Out': true,
    },
  ).then(
    (value) => value ?? false,
  );
}
