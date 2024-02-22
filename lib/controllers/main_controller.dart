import 'dart:async';
import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class MainController {
  final BuildContext context;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  MainController(
    this.context
  );

  bool get mounted => context.mounted;
  
  void initializeController() {
    getData();
  }

  void dispose() {
    isLoading.dispose();
  }

  Future<void> getData() async{
    try {
      await authRepo.verifyAccessToken(context);
      Bookshelves myBookshelves = await appStateRepo.booksApi!.mylibrary.bookshelves.list();
      if(myBookshelves.items != null){
        for(int i = 0; i < myBookshelves.items!.length; i++){
          Bookshelf bookshelf = myBookshelves.items![i];
          if(authRepo.profileData != null && bookshelf.id != null){
            if(!blacklistedBookshelves.contains(bookshelf.id)){
              Volumes volumes = await appStateRepo.booksApi!.mylibrary.bookshelves.volumes.list(
                bookshelf.id!.toString(),
                maxResults: maxFrontDisplay
              );
              if(appStateRepo.globalBookshelves[authRepo.profileData!.id] == null){
                appStateRepo.globalBookshelves[authRepo.profileData!.id] = {};
              }
              appStateRepo.globalBookshelves[authRepo.profileData!.id]![bookshelf.id!] = BookshelfCompleteClass(
                bookshelf,
                List<String>.from(volumes.items != null ? volumes.items!.map((e) => e.id).toList() : [])
              );
              if(volumes.items != null){
                for(int j = 0; j < volumes.items!.length; j++){
                  Volume volume = volumes.items![j];
                  if(volume.id != null){
                    appStateRepo.globalVolumes[volume.id!] = volume;
                  }
                }
              }
            }
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