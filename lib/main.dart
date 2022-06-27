// ignore_for_file: use_key_in_widget_constructors

//import 'dart:convert';
//import 'dart:io';
//import 'dart:js';
import 'dart:developer' as devtools show log;

// import 'package:bloc_tutorial/apis/login_api.dart';
// import 'package:bloc_tutorial/apis/notes_api.dart';
// import 'package:bloc_tutorial/bloc/action.dart';
// import 'package:bloc_tutorial/bloc/app_bloc.dart';
// import 'package:bloc_tutorial/bloc/app_state.dart';
// import 'package:bloc_tutorial/dialogs/Loading_Screen.dart';
// import 'package:bloc_tutorial/dialogs/generic_dialog.dart';
// import 'package:bloc_tutorial/models.dart';
// import 'package:bloc_tutorial/view/iterable_list_view.dart';
// import 'package:bloc_tutorial/view/login_view.dart';
import 'package:bloc_tutorial/views/home_page.dart';
import 'package:flutter/material.dart';
//import 'package:bloc/bloc.dart';
//import 'dart:math' as math show Random;
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:bloc_tutorial/Strings.dart';

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
