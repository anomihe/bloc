import 'package:flutter/foundation.dart';

@immutable
class LoginHandle {
  final String token;
  const LoginHandle({
    required this.token,
  });
  const LoginHandle.fooBar() : token = 'fooBar';

  @override
  bool operator ==(covariant LoginHandle other) => token == other.token;

  @override
  int get hashCode => token.hashCode;

  @override
  String toString() => 'LoginHandle (token = $token)';
}

enum LoginErrors { invlidHandles }

@immutable
class Note {
  final String title;
  const Note({
    required this.title,
  });

  @override
  @override
  String toString() => 'Note (title = $title)';
}

final mockNotes = Iterable.generate(
  3,
  (i) => Note(title: 'Note ${i + 1}'),
);