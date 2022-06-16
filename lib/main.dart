// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
//import 'dart:js';
import 'dart:developer' as devtools show log;

import 'package:bloc_tutorial/bloc/bloc_action.dart';
import 'package:bloc_tutorial/bloc/person.dart';
import 'package:bloc_tutorial/bloc/persons_bloc.dart';
import 'package:flutter/material.dart';
//import 'package:bloc/bloc.dart';
//import 'dart:math' as math show Random;
import 'package:flutter_bloc/flutter_bloc.dart';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  runApp(MaterialApp(
    title: 'Bloc demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider(create: (context) => PersonBloc(), child: HomePage()),
  ));
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
//geturl creates a request
    .getUrl(Uri.parse(url))
    //the request goes in here and becomes a response
    .then((req) => req.close())
    //response goes in here and beoomes a string
    .then((resp) => resp.transform(utf8.decoder).join())
    //string goes in here and becomes a list
    .then((str) => jsonDecode(str) as List<dynamic>)
    // list goes in here and becomes an iterable which becomes a result in the end
    .then((list) => list.map((e) => Person.fromJson(e)));

//everything here is just conversion
extension Subscription<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('home page')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(
                              url: persons1Url, loader: getPersons),
                        );
                  },
                  child: const Text('load json 1')),
              TextButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(
                              url: persons2Url, loader: getPersons),
                        );
                  },
                  child: const Text('load json 2')),
            ],
          ),
          BlocBuilder<PersonBloc, FetchResult?>(
              buildWhen: ((previous, current) {
            return previous?.person != current?.person;
          }), builder: (context, state) {
            //  state?.log();
            final persons = state?.person;
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                itemCount: persons.length,
                itemBuilder: ((context, index) {
                  final person = persons[index]!;
                  return ListTile(
                    title: Text(person.name),
                  );
                }),
              ),
            );
          })
        ],
      ),
    );
  }
}
