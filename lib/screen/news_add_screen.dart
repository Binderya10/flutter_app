import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/model/widget/news_model.dart';
import 'package:flutter_app/utilities/globalState.dart';
import 'package:flutter_app/utilities/globals.dart';
import 'package:flutter_app/widget/common/main_app_bar.dart';
import 'package:flutter_app/widget/common/main_button.dart';
import 'package:flutter_app/widget/common/main_input.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class NewsAddScreen extends StatefulWidget {
  const NewsAddScreen({Key? key}) : super(key: key);

  @override
  State<NewsAddScreen> createState() => _NewsAddScreenState();
}

class _NewsAddScreenState extends State<NewsAddScreen> {
  TextEditingController _titleController = TextEditingController();

  globalState _state = globalState();

  _imagePicker() async {
    debugPrint("OK");
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    // final LostDataResponse response = await picker.retrieveLostData();
    // if (response.isEmpty) {
    //   return;
    // }
    // final List<XFile>? files = response.files;
    // if (files != null) {
    //   debugPrint(files.toString());
    // } else {
    //   Get.snackbar("Алдаа", response.exception!.message ?? "");
    // }
  }

  _save() {
    if (_titleController.text.length != 0) {
      _state.list.add(
        new NewsModel(
          id: Random().toString(),
          title: _titleController.text,
          imgUrl: "/uploads/id/news/kLpeFaJpMdybqJWhZUrV.png",
          createdAt: new DateTime.now(),
        ),
      );
      _state.list.refresh();

      Get.back(
        // result: "Sain bn uu"
        result: NewsModel(
          id: Random().toString(),
          title: _titleController.text,
          imgUrl: "/uploads/id/news/kLpeFaJpMdybqJWhZUrV.png",
          createdAt: new DateTime.now(),
        ),
      );
    } else {
      Get.snackbar("Анхаар", "Гарчиг оруулна уу");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: "Мэдээ нэмэх",
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(
          top: 30,
          bottom: 30,
          left: 15,
          right: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            MainInput(
              controller: _titleController,
              hintText: "Гарчиг оруулна уу",
            ),
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () => _imagePicker,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
                child: Text("Зураг оруулах"),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Mainbutton(
              text: 'Хадгалах',
              onPress: _save,
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      )),
    );
  }
}
