import 'package:bloc_note/dialogs/generic_dialogs.dart';
import 'package:bloc_note/strings.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController, passwordController;
  final OnLoginTapped onLoginTapped;
  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          final email = emailController.text;
          final password = passwordController.text;
          if (email.isEmpty || password.isEmpty) {
            showGenricDialog<bool>(
              context: context,
              title: emailOrPasswordEmptyDialogTitle,
              constent: emailOrPasswordEmptyDescriptor,
              optionBuilder: () => {
                ok: true,
              },
            );
          } else {
            onLoginTapped(
              email,
              password,
            );
          }
        },
        child: const Text(login));
  }
}
