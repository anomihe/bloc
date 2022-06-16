import 'package:bloc_tutorial/bloc/person.dart';
import 'package:flutter/foundation.dart' show immutable;

// enum PersonUrl {
//   person1,
//   person2,
// }

// extension UrlString on PersonUrl {
//   String get urlString {
//     switch (this) {
//       case PersonUrl.person1:
//         return 'http://127.0.0.1:5500/api/people1.json';
//       case PersonUrl.person2:
//         return 'http://127.0.0.1:5500/api/people2.json';
//     }
//   }
// }

const persons1Url = 'http://127.0.0.1:5500/api/people1.json';
const persons2Url = 'http://127.0.0.1:5500/api/people1.json';

typedef PersonLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonAction implements LoadAction {
  final String url;
  final PersonLoader loader;
  const LoadPersonAction({
    required this.url,
    required this.loader,
  });
}
