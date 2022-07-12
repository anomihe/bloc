import 'package:bloc_tutorial/bloc/app_bloc.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/dialogs/shiw_auth_error.dart';
import 'package:bloc_tutorial/loading/loading_screen.dart';
import 'package:bloc_tutorial/views/login_viiew.dart';
import 'package:bloc_tutorial/views/photo_gallery_view.dart';
import 'package:bloc_tutorial/views/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateInRegistrationView) {
              return const RegisterView();
            } else {
              return Container();
            }
          },
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading...',
              );
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                autherror: authError,
                context: context,
              );
            }
          },
        ),
      ),
    );
  }
}
