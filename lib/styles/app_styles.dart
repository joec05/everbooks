import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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

double defaultHorizontalPadding = getScreenWidth() * 0.02;

double defaultVerticalPadding = getScreenHeight() * 0.01;

Widget shimmerSkeletonWidget(Widget child){
  return Shimmer.fromColors(
    baseColor: Colors.grey.withOpacity(0.5),
    highlightColor: const Color.fromARGB(179, 167, 155, 155),
    child: child
  );
}

Image unknownItemBasicImage = Image.asset(
  unknownItemLink,
  width: (getScreenWidth() - defaultHorizontalPadding * 2) / 5,
  height: getScreenHeight() * 0.16,
  fit: BoxFit.cover,
);

ImageProvider unknownItemPosterImage = AssetImage(
  unknownItemLink,
);