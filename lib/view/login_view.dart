import 'package:bloc_tutorial/view/email_text_field.dart';
import 'package:bloc_tutorial/view/login_button.dart';
import 'package:bloc_tutorial/view/password_text_field.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(emailController: emailController),
          PasswordTextField(passwordController: passwordController),
          LoginButton(
            emailController: emailController,
            onLoginTapped: onLoginTapped,
            passwordController: passwordController,
          )
        ],
      ),
    );
  }
}
