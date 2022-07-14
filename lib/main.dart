import 'dart:developer' as devtools show log;

import 'package:bloc_tutorial/firebase_options.dart';
import 'package:bloc_tutorial/views/app.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const App(),
  );
}
