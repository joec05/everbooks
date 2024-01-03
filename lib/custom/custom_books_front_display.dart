import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/class/bookshelf_complete_class.dart';
import 'package:book_list_app/custom/custom_basic_image.dart';
import 'package:book_list_app/custom/custom_button.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:book_list_app/transition/navigation_transition.dart';
import 'package:book_list_app/view_bookshelf_volumes.dart';
import 'package:flutter/material.dart';

class CustomBooksFrontDisplay extends StatefulWidget {
  final BookshelfCompleteClass? bookshelfData;
  final bool skeletonMode;

  const CustomBooksFrontDisplay({
    super.key,
    required this.bookshelfData,
    required this.skeletonMode
  });

  @override
  State<CustomBooksFrontDisplay> createState() => CustomBooksFrontDisplayState();
}

class CustomBooksFrontDisplayState extends State<CustomBooksFrontDisplay>{
  late BookshelfCompleteClass? bookshelfData;

  @override
  void initState(){
    super.initState();
    bookshelfData = widget.bookshelfData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  void displayBookshelfInfo(){
    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (statefulBuilderContext, setState){
            return AlertDialog(
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
              content: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultHorizontalPadding * 1.5,
                  vertical: defaultVerticalPadding * 2
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text.rich(
                        textAlign: TextAlign.center,
                        TextSpan(
                          children: [
                            TextSpan(
                              text: bookshelfData!.bookshelf.title ?? '?',
                              style: const TextStyle(
                                fontSize: 19.5,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            WidgetSpan(
                              child: Container(
                                margin: EdgeInsets.only(
                                  left: getScreenWidth() * 0.01
                                ),
                                child: bookshelfData!.bookshelf.access == 'PRIVATE' ? 
                                  const Icon(
                                    Icons.lock,
                                    size: 20
                                  ) 
                                : 
                                  const Icon(
                                    Icons.lock,
                                    size: 0
                                  )
                              )
                            )
                          ]
                        )
                      ),
                      Text(
                        '${bookshelfData!.bookshelf.volumeCount} items'
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.02
                      ),
                      Text(
                        bookshelfData!.bookshelf.description ?? 'No description given',
                        style: TextStyle(
                          fontStyle: bookshelfData!.bookshelf.description != null ? FontStyle.normal : FontStyle.italic
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.025
                      ),
                      Text(
                        'Created at ${bookshelfData!.bookshelf.created != null ? convertDateTimeDisplay(bookshelfData!.bookshelf.created!) : '?'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey
                        )
                      ),
                      Text(
                        'Last updated at ${bookshelfData!.bookshelf.volumesLastUpdated != null ? convertDateTimeDisplay(bookshelfData!.bookshelf.volumesLastUpdated!) : '?'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.blueGrey
                        )
                      )
                    ]
                  )
                )
              )
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context){
    if(bookshelfData == null || widget.skeletonMode){
      return Container(
        margin: EdgeInsets.symmetric(
          vertical: getScreenHeight() * 0.025
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey,
              height: getScreenHeight() * 0.05,
              width: getScreenWidth() - defaultHorizontalPadding * 2,
            ),
            Container(
              margin: EdgeInsets.only(
                top: defaultVerticalPadding * 1.5
              ),
              color: Colors.grey,
              child: SizedBox(
                width: double.infinity,
                height: getScreenHeight() * 0.16
              )
            ),
            SizedBox(
              height: defaultVerticalPadding
            ),
            Container(
              width: double.infinity,
              height: getScreenHeight() * 0.065,
              color: Colors.grey
            )
          ],
        ),
      );
    }
    List<String> volumes = bookshelfData!.volumes.length > maxFrontDisplay ? bookshelfData!.volumes.sublist(0, maxFrontDisplay) : bookshelfData!.volumes;
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getScreenHeight() * 0.025
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                bookshelfData!.bookshelf.title ?? 'No title',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontStyle: bookshelfData!.bookshelf.title != null ? FontStyle.normal : FontStyle.italic
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              GestureDetector(
                onTap: displayBookshelfInfo,
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.info,
                    size: 22.5,
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: defaultVerticalPadding * 1.5
            ),
            child: volumes.isNotEmpty ?
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: volumes.length > 5 ? getScreenHeight() * 0.32 : getScreenHeight() * 0.16,
                    child: GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,    
                        childAspectRatio: 0.675
                      ),
                      physics: const PageScrollPhysics(),
                      children: volumes.map((e) => CustomBasicImage(
                        volumeData: appState.globalVolumes[e]!, 
                        skeletonMode: false
                      )).toList(),
                    )
                  ),
                  SizedBox(
                    height: defaultVerticalPadding
                  ),
                  CustomButton(
                    width: double.infinity, 
                    height: getScreenHeight() * 0.065,
                    buttonColor: Colors.green.withOpacity(0.65), 
                    buttonText: "View all",
                    onTapped: (){
                      Navigator.push(
                        context,
                        NavigationTransition(
                          page: ViewBookshelfVolumes(bookshelfData: widget.bookshelfData!)
                        )
                      );
                    }, 
                    setBorderRadius: true
                  )
                ],
              )
            :
              SizedBox(
                width: double.infinity,
                height: getScreenHeight() * 0.16,
                child: const Center(
                  child: Text('No books found')
                )
              ),
          )
        ],
      ),
    );
  }
}