import 'dart:math';
import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class BookshelfVolumesController {
  final BuildContext context;
  final BookshelfCompleteClass bookshelfData;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  BookshelfVolumesController(
    this.context,
    this.bookshelfData
  );

  bool get mounted => context.mounted;

  void initializeController() {
    getData();
  }

  void dispose(){
    isLoading.dispose();
  }

  void getData() async{
    try {
      await authRepo.verifyAccessToken(context);
      Volumes volumes = await appStateRepo.booksApi!.mylibrary.bookshelves.volumes.list(bookshelfData.bookshelf.id!.toString());
      if(appStateRepo.globalBookshelves[authRepo.profileData!.id] == null){
        appStateRepo.globalBookshelves[authRepo.profileData!.id] = {};
      }
      appStateRepo.globalBookshelves[authRepo.profileData!.id]![bookshelfData.bookshelf.id!] = BookshelfCompleteClass(
        bookshelfData.bookshelf,
        List<String>.from(volumes.items != null ? volumes.items!.map((e) => e.id).toList() : [])
      );
      if(volumes.items != null){
        for(int j = 0; j < min(maxFrontDisplay, volumes.items!.length); j++){
          Volume volume = volumes.items![j];
          if(volume.id != null){
            appStateRepo.globalVolumes[volume.id!] = volume;
          }
        }
      }
    } catch (_) {
      if(mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
        );
      }
    }
    if(mounted){
      isLoading.value = false;
    }
  }
}