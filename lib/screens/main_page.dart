import 'dart:async';
import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainPageWidgetStateful();
  }
}

class _MainPageWidgetStateful extends StatefulWidget {
  const _MainPageWidgetStateful();

  @override
  State<_MainPageWidgetStateful> createState() => __MainPageWidgetStatefulState();
}

class __MainPageWidgetStatefulState extends State<_MainPageWidgetStateful>{
  late StreamSubscription updateBookshelfVolumesStreamClassSubscription;
  late MainController controller;
  
  @override
  void initState(){
    super.initState();
    controller = MainController(context);
    controller.initializeController();
    updateBookshelfVolumesStreamClassSubscription = UpdateBookshelfVolumesStreamClass().updateBookshelfStream.listen((BookshelfVolumesStreamControllerClass data) {
      if(mounted){
        setState((){});
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
    updateBookshelfVolumesStreamClassSubscription.cancel();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: controller.isLoading, 
      builder: (context, isLoadingValue, child) {
        if(isLoadingValue){
          return Scaffold(
            appBar: AppBar(
              flexibleSpace: Container(
                decoration: defaultAppBarDecoration
              ),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: getScreenWidth() * 0.025,
                      ),
                      const Text('Everbooks'),
                    ],
                  ),
                ]
              ), 
              titleSpacing: defaultAppBarTitleSpacing,
            ),
            body: shimmerSkeletonWidget(
              CustomMainPage(
                skeletonMode: true,
                key: UniqueKey()
              ),
            )
          );
        }
        return Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: defaultAppBarDecoration
            ),
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: getScreenWidth() * 0.025,
                    ),
                    const Text('Everbooks'),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,                  
                      onTap: (){
                        Navigator.push(
                          context,
                          NavigationTransition(
                            page: const SearchPageWidget()
                          )
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenWidth() * 0.05,
                          vertical: getScreenHeight() * 0.01
                        ),
                        child: const Icon(FontAwesomeIcons.magnifyingGlass, size: 22.5),
                      )
                    ),  
                    SizedBox(
                      width: getScreenWidth() * 0.005,
                    )
                  ],
                )
              ]
            ), 
            titleSpacing: defaultAppBarTitleSpacing,
          ),
          body: RefreshIndicator(
            onRefresh: controller.getData,
            child: CustomMainPage(
              skeletonMode: false,
              key: UniqueKey()
            ),
          )
        );
      }
    );
  }
}