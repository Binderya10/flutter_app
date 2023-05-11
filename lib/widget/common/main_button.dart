import 'package:flutter/material.dart';

class Mainbutton extends StatelessWidget {
  final String text;
  final VoidCallback? onPress;

  const Mainbutton({Key? key, required this.text, this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        onPrimary: Colors.white,
        primary: Colors.green,
        minimumSize: const Size.fromHeight(50),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
          textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
      ),
      onPressed: this.onPress,
      child: Text(this.text),
    );
  }
}
