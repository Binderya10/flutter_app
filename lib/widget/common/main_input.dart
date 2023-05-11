import 'package:flutter/material.dart';

class MainInput extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  const MainInput({Key? key, required this.controller, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
      ),
    );
  }
}
