import 'dart:async';
import 'dart:math';
import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/class/bookshelf_complete_class.dart';
import 'package:book_list_app/custom/custom_book_row_display.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/stream/update_bookshelf_volumes_class.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class ViewBookshelfVolumes extends StatelessWidget {
  final BookshelfCompleteClass bookshelfData;

  const ViewBookshelfVolumes({
    super.key,
    required this.bookshelfData,
  });

  @override
  Widget build(BuildContext context) {
    return _ViewBookshelfVolumesStateful(
      bookshelfData: bookshelfData
    );
  }
}

class _ViewBookshelfVolumesStateful extends StatefulWidget {
  final BookshelfCompleteClass bookshelfData;

  const _ViewBookshelfVolumesStateful({
    required this.bookshelfData,
  });

  @override
  State<_ViewBookshelfVolumesStateful> createState() => __ViewBookshelfVolumesStatefulState();
}

class __ViewBookshelfVolumesStatefulState extends State<_ViewBookshelfVolumesStateful>{
  late BookshelfCompleteClass bookshelfData;
  late StreamSubscription updateBookshelfVolumesStreamClassSubscription;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    bookshelfData = widget.bookshelfData;
    getData();
    updateBookshelfVolumesStreamClassSubscription = UpdateBookshelfVolumesStreamClass().userAnimeListStream.listen((BookshelfVolumesStreamControllerClass data) {
      if(mounted){
        if(data.bookshelfID == bookshelfData.bookshelf.id!){
          setState((){});
        }
      }
    });
  }

  @override
  void dispose(){
    super.dispose();
    updateBookshelfVolumesStreamClassSubscription.cancel();
  }

  void getData() async{
    await verifyAccessToken();
    BookshelfCompleteClass bookshelf = widget.bookshelfData;
    Volumes volumes = await appState.booksApi!.mylibrary.bookshelves.volumes.list(bookshelf.bookshelf.id!.toString());
    if(appState.globalBookshelves[appState.profileData!.id] == null){
      appState.globalBookshelves[appState.profileData!.id] = {};
    }
    appState.globalBookshelves[appState.profileData!.id]![bookshelf.bookshelf.id!] = BookshelfCompleteClass(
      bookshelf.bookshelf,
      List<String>.from(volumes.items != null ? volumes.items!.map((e) => e.id).toList() : [])
    );
    if(volumes.items != null){
      for(int j = 0; j < min(maxFrontDisplay, volumes.items!.length); j++){
        Volume volume = volumes.items![j];
        if(volume.id != null){
          appState.globalVolumes[volume.id!] = volume;
        }
      }
    }
    if(mounted){
      setState((){
        isLoading = false;
      });
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
          title: const Text('Volumes'),
          titleSpacing: defaultAppBarTitleSpacing,
        ),
        body: ListView.builder(
          itemCount: defaultShimmerLength,
          itemBuilder: (context, index){
            return shimmerSkeletonWidget(
              CustomBookRowDisplay(
                volumeData: null, 
                skeletonMode: true,
                key: UniqueKey(),
              ),
            );
          },
        )
      );
    }
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration
        ),
        title: const Text('Volumes'),
        titleSpacing: defaultAppBarTitleSpacing,
      ),
      body: ListView.builder(
        itemCount: appState.globalBookshelves[appState.profileData!.id]![bookshelfData.bookshelf.id]!.volumes.length,
        itemBuilder: (context, index){
          Volume? volume = appState.globalVolumes[appState.globalBookshelves[appState.profileData!.id]![bookshelfData.bookshelf.id]!.volumes[index]];
          if(volume == null){
            return Container();
          }

          return CustomBookRowDisplay(
            volumeData: volume, 
            skeletonMode: false,
            key: UniqueKey(),
          );
        },
      )
    );
  }
}