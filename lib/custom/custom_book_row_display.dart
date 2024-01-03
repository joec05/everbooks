import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/custom/custom_basic_image.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:book_list_app/transition/navigation_transition.dart';
import 'package:book_list_app/view_book_details.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class CustomBookRowDisplay extends StatefulWidget {
  final Volume? volumeData;
  final bool skeletonMode;

  const CustomBookRowDisplay({
    super.key,
    required this.volumeData,
    required this.skeletonMode
  });

  @override
  State<CustomBookRowDisplay> createState() => CustomBookRowDisplayState();
}

class CustomBookRowDisplayState extends State<CustomBookRowDisplay>{
  late Volume? volumeData;

  @override
  void initState(){
    super.initState();
    volumeData = widget.volumeData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    if(volumeData == null || widget.skeletonMode){
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
          horizontal: defaultHorizontalPadding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomBasicImage(
              volumeData: null, 
              skeletonMode: true
            ),
            SizedBox(
              width: getScreenWidth() * 0.025
            ),
            Container(
              color: Colors.grey,
              height: getScreenHeight() * 0.16,
              width: ((getScreenWidth() - defaultHorizontalPadding * 2) / 5) * 4 - (getScreenWidth() * 0.025)
            )
          ],
        )
      );
    }
    
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      onTap: () async{
        Future.delayed(const Duration(milliseconds: 400), (){
          Navigator.push(
            context,
            NavigationTransition(
              page: ViewBookDetails(
                volumeData: widget.volumeData!,
              )
            )
          );
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: defaultVerticalPadding,
          horizontal: defaultHorizontalPadding
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomBasicImage(
              volumeData: volumeData!, 
              skeletonMode: false
            ),
            SizedBox(
              width: getScreenWidth() * 0.025
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text.rich(
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: volumeData!.volumeInfo!.title ?? '?',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: volumeData!.volumeInfo!.authors == null ? ' by ?' : ' by ${volumeData!.volumeInfo!.authors!.join(', ')}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 104, 102, 102)
                          )
                        )
                      ]
                    )
                  )
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}