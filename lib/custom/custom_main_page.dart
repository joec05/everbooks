import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/custom/custom_books_front_display.dart';
import 'package:book_list_app/custom/custom_user_profile.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CustomMainPage extends StatefulWidget {
  final bool skeletonMode;

  const CustomMainPage({
    super.key,
    required this.skeletonMode
  });

  @override
  State<CustomMainPage> createState() => CustomMainPageState();
}

class CustomMainPageState extends State<CustomMainPage>{

  @override
  Widget build(BuildContext context){
    if(widget.skeletonMode){
      return ListView(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: defaultVerticalPadding,
              horizontal: defaultHorizontalPadding
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerSkeletonWidget(
                  const CustomUserProfile(
                    skeletonMode: true,
                  ),
                ),
                Column(
                  children: [
                    for(int i = 0; i < defaultShimmerLength; i++)
                    shimmerSkeletonWidget(
                      CustomBooksFrontDisplay(
                        bookshelfData: null, 
                        skeletonMode: true,
                        key: UniqueKey()
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      );
    }
    return ListView(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: defaultVerticalPadding,
            horizontal: defaultHorizontalPadding
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomUserProfile(
                skeletonMode: false,
              ),
              appState.globalBookshelves[appState.profileData!.id] == null ? Container() :
              Column(
                children: [
                  for(int i = 0; i < appState.globalBookshelves[appState.profileData!.id]!.keys.toList().length; i++)
                  CustomBooksFrontDisplay(
                    bookshelfData: appState.globalBookshelves[appState.profileData!.id]!.values.toList()[i], 
                    skeletonMode: false,
                    key: UniqueKey()
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}