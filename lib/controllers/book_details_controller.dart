import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class BookDetailsController {
  final BuildContext context;
  final Volume volumeData;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  BookDetailsController(
    this.context,
    this.volumeData
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
      Volume volume = await appStateRepo.booksApi!.volumes.get(volumeData.id!);
      appStateRepo.globalVolumes[volume.id!] = volume;
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

  void selectBookshelves(){
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<BookshelfCompleteClass> bookshelvesList = [...appStateRepo.globalBookshelves[authRepo.profileData!.id]!.values.toList()];
        List<int> bookshelvesContainOriginal = bookshelvesList.where((e) => e.volumes.contains(volumeData.id!)).map((e) => e.bookshelf.id!).toList();
        List<int> bookshelvesContain = [...bookshelvesContainOriginal];
        List<String> bookshelvesNameList = [...bookshelvesList.map((e) => e.bookshelf.title ?? '?').toList()];
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
                      for(int i = 0; i < bookshelvesNameList.length; i++)
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: (){
                          if(mounted){
                            setState((){
                              if(bookshelvesContain.contains(bookshelvesList[i].bookshelf.id!)){
                                bookshelvesContain.remove(bookshelvesList[i].bookshelf.id!);
                              }else{
                                bookshelvesContain.add(bookshelvesList[i].bookshelf.id!);
                              }
                            });
                          }
                        },
                        child: SizedBox(
                          height: getScreenHeight() * 0.065,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getScreenWidth() * 0.1,
                                child: bookshelvesContain.contains(bookshelvesList[i].bookshelf.id!) ? const Icon(Icons.check) : Container()
                              ),
                              Text(bookshelvesNameList[i])
                            ]
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.025
                      ),
                      Center(
                        child: CustomButton(
                          width: getScreenWidth() * 0.45, 
                          height: getScreenHeight() * 0.06, 
                          buttonColor: const Color.fromARGB(255, 17, 78, 128), 
                          buttonText: 'Update', 
                          onTapped: (){
                            updateVolumeBookshelves(bookshelvesContainOriginal, bookshelvesContain);
                            Navigator.pop(dialogContext);
                          }, 
                          setBorderRadius: true
                        ),
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

  void updateVolumeBookshelves(List<int> originalList, List<int> newList) async{
    try {
      List<int> combinedList = {...originalList, ...newList}.toList();
      for(int i = 0; i < combinedList.length; i++){
        if(originalList.contains(combinedList[i]) && !newList.contains(combinedList[i])){
          appStateRepo.booksApi!.mylibrary.bookshelves.removeVolume(combinedList[i].toString(), volumeData.id!);
          appStateRepo.globalBookshelves[authRepo.profileData!.id]![combinedList[i]]!.volumes.remove(volumeData.id!);
          UpdateBookshelfVolumesStreamClass().emitData(BookshelfVolumesStreamControllerClass(
            combinedList[i]
          ));
        }else if(!originalList.contains(combinedList[i]) && newList.contains(combinedList[i])){
          appStateRepo.booksApi!.mylibrary.bookshelves.addVolume(combinedList[i].toString(), volumeData.id!);
          appStateRepo.globalBookshelves[authRepo.profileData!.id]![combinedList[i]]!.volumes.insert(0, volumeData.id!);
          UpdateBookshelfVolumesStreamClass().emitData(BookshelfVolumesStreamControllerClass(
            combinedList[i]
          ));
        }
      }
      if(mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.successful, 
          tSuccess.updated
        );
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