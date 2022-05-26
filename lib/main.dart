import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_note/apis/login_api.dart';
import 'package:bloc_note/apis/notes_api.dart';
import 'package:bloc_note/bloc/action.dart';
import 'package:bloc_note/bloc/app_state.dart';
import 'package:bloc_note/dialogs/loading_screen.dart';
import 'package:bloc_note/models.dart';
import 'package:bloc_note/strings.dart';
import 'package:bloc_note/views/iterable_list_view.dart';
import 'package:bloc_note/views/login_view.dart';


import 'bloc/app_bloc.dart';
import 'dialogs/generic_dialogs.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bloc Note',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenricDialog<bool>(
                context: context,
                title: loginErrorDialogTitle,
                constent: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }
            // if we are logged in, but we have no fetched notes, fetch them now
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
