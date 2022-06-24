// ignore_for_file: use_key_in_widget_constructors

//import 'dart:convert';
//import 'dart:io';
//import 'dart:js';
import 'dart:developer' as devtools show log;

import 'package:bloc_tutorial/apis/login_api.dart';
import 'package:bloc_tutorial/apis/notes_api.dart';
import 'package:bloc_tutorial/bloc/action.dart';
import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/dialogs/Loading_Screen.dart';
import 'package:bloc_tutorial/dialogs/generic_dialog.dart';
import 'package:bloc_tutorial/models.dart';
import 'package:bloc_tutorial/view/iterable_list_view.dart';
import 'package:bloc_tutorial/view/login_view.dart';
import 'package:flutter/material.dart';
//import 'package:bloc/bloc.dart';
//import 'dart:math' as math show Random;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_tutorial/Strings.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(
    MaterialApp(
      title: 'Bloc demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        noteApi: NotesApi(),
        acceptableLoginHandle: const LoginHandle.fooBar(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, state) {
            //loadin screen
            if (state.isLoading) {
              LoadingScreen.instance().show(context: context, text: pleaseWait);
            } else {
              LoadingScreen.instance().hide();
            }
            //display possible errors
            final loginError = state.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {ok: true},
              );
            }
            //if we are logged in, but we have no fetched notes, fetch them now
            if (state.isLoading == false &&
                state.loginError == null &&
                state.loginHandle == const LoginHandle.fooBar() &&
                state.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context
                      .read<AppBloc>()
                      .add(LoginAction(email: email, password: password));
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
