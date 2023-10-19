import 'package:flutter/material.dart';

import '../components/auth_form.dart';

class RegisterAuthPage extends StatefulWidget {
  final String title = "Register";
  const RegisterAuthPage({super.key});

  @override
  State<RegisterAuthPage> createState() => _RegisterAuthPageState();
}

class _RegisterAuthPageState extends State<RegisterAuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: RegisterAuthForm()
      ),
    );
  }
}
