import 'package:book_list_app/global_files.dart';
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
              appStateRepo.globalBookshelves[authRepo.profileData!.id] == null ? Container() :
              Column(
                children: [
                  for(int i = 0; i < appStateRepo.globalBookshelves[authRepo.profileData!.id]!.keys.toList().length; i++)
                  CustomBooksFrontDisplay(
                    bookshelfData: appStateRepo.globalBookshelves[authRepo.profileData!.id]!.values.toList()[i], 
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