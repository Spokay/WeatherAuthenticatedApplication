import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class LoginAuthPage extends StatefulWidget {
  final String title = "Login";
  const LoginAuthPage({super.key});

  @override
  State<LoginAuthPage> createState() => _LoginAuthPageState();
}

class _LoginAuthPageState extends State<LoginAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
          child: LoginAuthForm()
      ),
    );
  }
}
