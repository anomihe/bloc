import 'dart:html';

import 'package:bloc_tutorial/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_action.dart';

extension IsEqualToIgnoringOrdering<T> on Iterable<T> {
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
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

  @override
  bool operator ==(covariant FetchResult other) =>
      person.isEqualToIgnoringOrdering(other.person) &&
      isRetrivedFromCache == other.isRetrivedFromCache;
  @override
  int get hashCode => Object.hash(
        person,
        isRetrivedFromCache,
      );
}

class PersonBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _cache = {};
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
        final loader = event.loader;
        final person = await loader(url);
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
