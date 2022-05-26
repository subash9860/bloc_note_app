import 'package:bloc_note/views/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'login_button.dart';
import 'password_text_field.dart';

class LoginView extends HookWidget {
  final OnLoginTapped onLoginTapped;
  const LoginView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return Column(
      children: [
        const SizedBox(height: 40),
        EmailTextField(emailController: emailController),
        const SizedBox(height: 40),
        PasswordTextField(passwordController: passwordController),
        const SizedBox(height: 20),
        LoginButton(
          emailController: emailController,
          passwordController: passwordController,
          onLoginTapped: onLoginTapped,
        ),
      ],
    );
  }
}
