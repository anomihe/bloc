import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/dialogs/delete_acccount_dialog.dart';
import 'package:bloc_tutorial/dialogs/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum MenuAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  const MainPopupMenuButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuAction>(
      onSelected: (value) async {
        switch (value) {
          case MenuAction.logout:
            final shouldLogOut = await showLogOutDialog(context);
            if (shouldLogOut) {
              context.read<AppBloc>().add(
                    const AppEventLogOut(),
                  );
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context);
            if (shouldDeleteAccount) {
              context.read<AppBloc>().add(
                    const AppEventDeleteAccount(),
                  );
            }
            break;
          default:
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem<MenuAction>(
            value: MenuAction.logout,
            child: Text('Log Out'),
          ),
          const PopupMenuItem<MenuAction>(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          )
        ];
      },
    );
  }
}
