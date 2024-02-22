import 'dart:async';
import 'package:book_list_app/global_files.dart';
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
  late BookshelfVolumesController controller;

  @override
  void initState(){
    super.initState();
    bookshelfData = widget.bookshelfData;
    controller = BookshelfVolumesController(context, bookshelfData);
    controller.initializeController();
    updateBookshelfVolumesStreamClassSubscription = UpdateBookshelfVolumesStreamClass().updateBookshelfStream.listen((BookshelfVolumesStreamControllerClass data) {
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
            itemCount: appStateRepo.globalBookshelves[authRepo.profileData!.id]![bookshelfData.bookshelf.id]!.volumes.length,
            itemBuilder: (context, index){
              Volume? volume = appStateRepo.globalVolumes[appStateRepo.globalBookshelves[authRepo.profileData!.id]![bookshelfData.bookshelf.id]!.volumes[index]];
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
    );
  }
}