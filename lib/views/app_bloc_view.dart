import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/bloc/bloc_events.dart';
import 'package:bloc_tutorial/extension/stream/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);
  void startUpdateingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(
            event,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdateingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(builder: (context, appState) {
        if (appState.error != null) {
          //we have an error
          return const Text('An error occurred. Try again in a moment!');
        } else if (appState.data != null) {
          //we have data
          return Image.memory(
            appState.data!,
            fit: BoxFit.fitHeight,
          );
        } else {
          //we have nothing
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}