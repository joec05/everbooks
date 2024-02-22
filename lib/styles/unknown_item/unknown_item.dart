import 'package:flutter/material.dart';
import 'package:book_list_app/global_files.dart';

Image unknownItemBasicImage = Image.asset(
  unknownItemLink,
  width: (getScreenWidth() - defaultHorizontalPadding * 2) / 5,
  height: getScreenHeight() * 0.16,
  fit: BoxFit.cover,
);

ImageProvider unknownItemPosterImage = AssetImage(
  unknownItemLink,
);