import 'dart:ui';

class NewsModel {
  String id;
  String title;
  String? imgUrl;
  DateTime createdAt;
  VoidCallback? onPress;

  NewsModel({required this.id,required this.title, this.imgUrl,required this.createdAt, this.onPress});
}