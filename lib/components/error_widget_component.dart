import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorWidgetComponent extends StatelessWidget {
  final String errorMessage;
  const ErrorWidgetComponent({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(errorMessage),
      ),
    );
  }
}
