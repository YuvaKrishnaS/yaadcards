import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
part 'flashcard.g.dart';

@HiveType(typeId: 0)
class Flashcard extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String? imagePath;

  @HiveField(3)
  String? link;

  @HiveField(4)
  int colorValue;

  @HiveField(5)
  DateTime createdAt;

  Flashcard({
    required this.title,
    required this.description,
    this.imagePath,
    this.link,
    required this.colorValue,
    required this.createdAt,
  });

  Color get color => Color(colorValue);

  static const List<Color> predefinedColors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
  ];
}