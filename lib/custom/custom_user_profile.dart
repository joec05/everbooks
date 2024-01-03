import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:flutter/material.dart';

class CustomUserProfile extends StatefulWidget {
  final bool skeletonMode;

  const CustomUserProfile({
    super.key,
    required this.skeletonMode
  });

  @override
  State<CustomUserProfile> createState() => CustomUserProfileState();
}

class CustomUserProfileState extends State<CustomUserProfile>{

  @override
  Widget build(BuildContext context){
    if(widget.skeletonMode){
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: getScreenHeight() * 0.015,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: getScreenWidth() * 0.135 / 2,
              backgroundImage: AssetImage(unknownItemLink)
            ),
            SizedBox(
              width: getScreenWidth() * 0.035,
            ),
            Container(
              height: getScreenWidth() * 0.135 * 0.75,
              width: getScreenWidth() * 0.83 - defaultHorizontalPadding * 2,
              color: Colors.grey,
            )
          ],
        ),
      );  
    }
    if(appState.profileData == null){
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getScreenHeight() * 0.015,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: getScreenWidth() * 0.135,
            height: getScreenWidth() * 0.135,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  appState.profileData!.profilePic,
                ),
                fit: BoxFit.cover,
                onError: (exception, stackTrace) => AssetImage(unknownItemLink),
              ),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: getScreenWidth() * 0.035,
          ),
          Text(
            appState.profileData!.name,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 19
            ),
          ),
        ],
      ),
    );
  }
}