import 'dart:io';

import 'package:bloc_tutorial/auth/auth_error.dart';
import 'package:bloc_tutorial/bloc/app_event.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateInRegistrationView(
          isLoading: false,
        ),
      );
    });
    on<AppEventLogIn>(
      ((event, emit) async {
        emit(
          const AppStateLoggedOut(
            isLoading: true,
          ),
        );
        try {
          final email = event.email;
          final password = event.password;
          final userCredential =
              await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          final user = userCredential.user!;
          final images = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              user: user,
              images: images,
              isLoading: false,
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedOut(
              authError: AuthError.from(e),
              isLoading: false,
            ),
          );
        }
      }),
    );
    on<AppEventGoToLogin>(
      ((event, emit) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }),
    );
    on<AppEventRegister>(
      ((event, emit) async {
        //start loading
        emit(
          const AppStateInRegistrationView(
            isLoading: true,
          ),
        );
        final email = event.email;
        final password = event.password;
        try {
          //create the user
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: credentials.user!,
              images: const [],
            ),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateInRegistrationView(
              isLoading: false,
              authError: AuthError.from(e),
            ),
          );
        }
      }),
    );
    //handle app initialization
    on<AppEventInitialize>(
      ((event, emit) async {
        //get the current user
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        } else {
          //go grab the user's uploaded images
          final image = await _getImages(user.uid);
          emit(
            AppStateLoggedIn(
              isLoading: false,
              user: user,
              images: image,
            ),
          );
        }
      }),
    );
    //handle log out event
    on<AppEventLogOut>((event, emit) async {
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      //log the user out
      await FirebaseAuth.instance.signOut();
      //log the user out in the ui as well
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });
    on<AppEventDeleteAccount>(
      ((event, emit) async {
        final user = FirebaseAuth.instance.currentUser;
        //log user out if we do not have have a current user
        if (user == null) {
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
          return;
        }
        //start loading
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: true,
          ),
        );
        //delete the user folder
        try {
          //delete user folder
          final folderContents =
              await FirebaseStorage.instance.ref(user.uid).listAll();
          for (final item in folderContents.items) {
            await item.delete().catchError((_) {}); // maybe handle error
          }
          //delete the folder itself
          await FirebaseStorage.instance
              .ref(user.uid)
              .delete()
              .catchError((_) {});

          //delete the user
          await user.delete();
          //log the user out
          await FirebaseAuth.instance.signOut();
          //log the user out in the UI
          emit(
            const AppStateLoggedOut(isLoading: false),
          );
        } on FirebaseAuthException catch (e) {
          emit(
            AppStateLoggedIn(
              user: user,
              images: state.images ?? [],
              isLoading: true,
              authError: AuthError.from(e),
            ),
          );
        } on FirebaseException {
          //we might not be able to delete the folder
          //log the user out
          emit(
            const AppStateLoggedOut(
              isLoading: false,
            ),
          );
        }
      }),
    );
    //handle uploading images
    on<AppEventUploadImage>((events, emit) async {
      final user = state.user;
      //logging the user out
      if (user == null) {
        emit(
          const AppStateLoggedOut(isLoading: false),
        );
        return;
      }
      //start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
        ),
      );
      //uploading a file
      final file = File(events.filePathToUpload);
      await UploadImage(file: file, userId: user.uid);
      //after upload is complete get the files get the latest files
      final images = await _getImages(user.uid);
      //turn off loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    });
  }
  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}


//state are the response of the user's actions 
//upon every event a new state needs to be emitted