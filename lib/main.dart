// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
//import 'dart:js';
import 'dart:developer' as devtools show log;

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

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final PersonUrl url;

  const LoadPersonAction({required this.url});
}

enum PersonUrl {
  person1,
  person2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.person1:
        return 'http://127.0.0.1:5500/api/people1.json';
      case PersonUrl.person2:
        return 'http://127.0.0.1:5500/api/people2.json';
    }
  }
}

@immutable
class Person {
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;

  @override
  String toString() => 'Person (name: $name, ade: $age)';
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

@immutable
class FetchResult {
  final Iterable<Person> person;
  final bool isRetrivedFromCache;

  const FetchResult({
    required this.person,
    required this.isRetrivedFromCache,
  });
  @override
  String toString() {
    return 'isRetrivedFromCache = $isRetrivedFromCache, person = $person';
  }
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonBloc() : super(null) {
    on<LoadPersonAction>((event, emit) async {
      final url = event.url;
      if (_cache.containsKey(url)) {
        final cachedPersons = _cache[url]!;
        final result = FetchResult(
          person: cachedPersons,
          isRetrivedFromCache: true,
        );
        emit(result);
      } else {
        final person = await getPersons(url.urlString);
        _cache[url] = person;
        final result = FetchResult(
          person: person,
          isRetrivedFromCache: false,
        );
        emit(result);
      }
    });
  }
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
                          const LoadPersonAction(url: PersonUrl.person1),
                        );
                  },
                  child: const Text('load json 1')),
              TextButton(
                  onPressed: () {
                    context.read<PersonBloc>().add(
                          const LoadPersonAction(url: PersonUrl.person2),
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
              return SizedBox();
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
