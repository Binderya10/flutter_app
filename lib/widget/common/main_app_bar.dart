import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MainAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {

    return AppBar(
      backgroundColor: Colors.white,
      leading: GestureDetector(
        child: Icon(
          Icons.arrow_back,
          color: Colors.blue,
        ),
        onTap: () {
          Get.back();
        },
      ),
      title: Text(
        this.title,
        style: TextStyle(color: Colors.blue),
      ),
    );
  }
}
