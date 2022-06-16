import 'package:bloc_tutorial/bloc/bloc_action.dart';
import 'package:bloc_tutorial/bloc/person.dart';
import 'package:bloc_tutorial/bloc/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'dart:html';

const mockedPerson1 = [
  Person(
    age: 20,
    name: 'foo',
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];
const mockedPerson2 = [
  Person(
    age: 20,
    name: 'foo',
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPerson1(String url) =>
    Future.value(mockedPerson1);

Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);

void main() {
  group('Testing bloc', () {
    //writing our test
    late PersonBloc bloc;
//the setup function allows to create a fresh copy of bloc so that\
//any test tha is done within the test group will have a fresh copy of PersonBloc()

    setUp(() {
      bloc = PersonBloc();
    });

    blocTest<PersonBloc, FetchResult?>(
      'Test initial state',
      build: () => bloc,
      verify: ((bloc) => bloc.state != null),
    );

    //fetch mock data (Person1) and compare it with fetchResult
    blocTest<PersonBloc, FetchResult?>('Mock retrieving from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonAction(
              url: 'dummy url 1', loader: mockGetPerson1));
          bloc.add(const LoadPersonAction(
              url: 'dummy url 1', loader: mockGetPerson1));
        },
        expect: () => [
              const FetchResult(
                  person: mockedPerson1, isRetrivedFromCache: false),
              const FetchResult(
                  person: mockedPerson1, isRetrivedFromCache: true)
            ]);
    //fetch mock data (Person2) and compare it with fetchResult
    blocTest<PersonBloc, FetchResult?>('Mock retrieving from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonAction(
              url: 'dummy url 2', loader: mockGetPerson2));
          bloc.add(const LoadPersonAction(
              url: 'dummy url 2', loader: mockGetPerson2));
        },
        expect: () => [
              const FetchResult(
                  person: mockedPerson2, isRetrivedFromCache: false),
              const FetchResult(
                  person: mockedPerson2, isRetrivedFromCache: true)
            ]);
  });
}
//flutter bloc testing is not the same with dart bloc testing, the command for bloc dart testing is
//not the same for flutter bloc testing. use flutter test