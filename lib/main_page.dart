import 'dart:async';
import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/class/bookshelf_complete_class.dart';
import 'package:book_list_app/custom/custom_main_page.dart';
import 'package:book_list_app/main.dart';
import 'package:book_list_app/search_page.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/stream/update_bookshelf_volumes_class.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:book_list_app/transition/navigation_transition.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googleapis/books/v1.dart';

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
  bool isLoading = true;
  
  @override
  void initState(){
    super.initState();
    getData();
    updateBookshelfVolumesStreamClassSubscription = UpdateBookshelfVolumesStreamClass().userAnimeListStream.listen((BookshelfVolumesStreamControllerClass data) {
      if(mounted){
        setState((){});
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateBookshelfVolumesStreamClassSubscription.cancel();
  }

  Future<void> getData() async{
    await verifyAccessToken();
    Bookshelves myBookshelves = await appState.booksApi!.mylibrary.bookshelves.list();
    if(myBookshelves.items != null){
      for(int i = 0; i < myBookshelves.items!.length; i++){
        Bookshelf bookshelf = myBookshelves.items![i];
        if(appState.profileData != null && bookshelf.id != null){
          if(!blacklistedBookshelves.contains(bookshelf.id)){
            Volumes volumes = await appState.booksApi!.mylibrary.bookshelves.volumes.list(
              bookshelf.id!.toString(),
              maxResults: maxFrontDisplay
            );
            if(appState.globalBookshelves[appState.profileData!.id] == null){
              appState.globalBookshelves[appState.profileData!.id] = {};
            }
            appState.globalBookshelves[appState.profileData!.id]![bookshelf.id!] = BookshelfCompleteClass(
              bookshelf,
              List<String>.from(volumes.items != null ? volumes.items!.map((e) => e.id).toList() : [])
            );
            if(volumes.items != null){
              for(int j = 0; j < volumes.items!.length; j++){
                Volume volume = volumes.items![j];
                if(volume.id != null){
                  appState.globalVolumes[volume.id!] = volume;
                }
              }
            }
          }
        }
      }
      if(mounted){
        setState((){
          isLoading = false;
        });
      }
    }
  }

  void logOut() async{
    await appState.signInConfig.signOut();
    if(mounted){
      Navigator.pushAndRemoveUntil(
        context,
        NavigationTransition(
          page: const MyHomePage(title: 'OK')
        ),
        (Route<dynamic> route) => false
      );
    }
  }

  @override
  Widget build(BuildContext context){
    if(isLoading){
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
        onRefresh: getData,
        child: CustomMainPage(
          skeletonMode: false,
          key: UniqueKey()
        ),
      )
    );
  }
}