//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

extension ToListView<T> on Iterable<T> {
  Widget toListView() => IterableListView(iterable: this);
}

class IterableListView<T> extends StatelessWidget {
  const IterableListView({Key? key, required this.iterable}) : super(key: key);
  final Iterable<T> iterable;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: iterable.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(iterable.elementAt(index).toString()),
        );
      },
    );
  }
}
