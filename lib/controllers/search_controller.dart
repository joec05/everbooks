import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class SearchPageController {
  final BuildContext context;
  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchedText = ValueNotifier('');
  ValueNotifier<List<String>> searchedBooks = ValueNotifier([]);
  FocusNode focusNode = FocusNode();
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  
  SearchPageController(
    this.context
  );

  bool get mounted => context.mounted;

  void initializeController() {}

  void dispose() {
    searchController.dispose();
    searchedText.dispose();
    searchedBooks.dispose();
    focusNode.dispose();
    isLoading.dispose();
  }

  void search() async{
    if(searchController.text.isNotEmpty){
      if(mounted) {
        isLoading.value = true;
      }
      focusNode.unfocus();
      await authRepo.verifyAccessToken();
      Volumes searchedVolumes = await appStateRepo.booksApi!.volumes.list(
        searchController.text,
        maxResults: 25,
        orderBy: 'relevance'
      );
      if(searchedVolumes.items != null){
        for(int i = 0; i < searchedVolumes.items!.length; i++){
          Volume volume = searchedVolumes.items![i];
          if(volume.id != null){
            appStateRepo.globalVolumes[volume.id!] = volume;
          }
        }
        if(mounted){
          searchedBooks.value = [...searchedVolumes.items!.map((e) => e.id as String).toList()];
          isLoading.value = false;
        }
      }else{
        if(mounted){
          searchedBooks.value = [];
          isLoading.value = false;
        }
      }
    }
  }
}