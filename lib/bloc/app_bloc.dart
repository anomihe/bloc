import 'package:bloc/bloc.dart';
import 'package:bloc_tutorial/apis/login_api.dart';
import 'package:bloc_tutorial/apis/notes_api.dart';
import 'package:bloc_tutorial/bloc/action.dart';
import 'package:bloc_tutorial/bloc/app_state.dart';
import 'package:bloc_tutorial/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  AppBloc({
    required this.loginApi,
    required this.noteApi,
    required this.acceptableLoginHandle,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      //start loading,
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      //start loading
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invlidHandles : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });
    on<LoadNotesAction>((event, emit) async {
      //start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );
      //get loginhandle
      final loginHandle = state.loginHandle;
      if (loginHandle != acceptableLoginHandle) {
        emit(
          AppState(
            isLoading: true,
            loginError: LoginErrors.invlidHandles,
            loginHandle: state.loginHandle,
            fetchedNotes: null,
          ),
        );
        return;
      }
      //we have a valid login handle and want to fetch notes
      final notes = await noteApi.getNotes(loginHandle: loginHandle!);
      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: notes,
        ),
      );
    });
  }
  final LoginApiProtocol loginApi;
  final NotesApiProtocol noteApi;
  final LoginHandle acceptableLoginHandle;
}
