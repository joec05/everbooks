import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';

BoxDecoration defaultAppBarDecoration = const BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [
      Color.fromARGB(255, 97, 136, 126), Color.fromARGB(255, 125, 145, 160)
    ],
    stops: [
      0.4, 0.75
    ],
  ),
);

double defaultAppBarTitleSpacing = getScreenWidth() * 0.02;