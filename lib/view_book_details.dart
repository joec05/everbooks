import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/class/bookshelf_complete_class.dart';
import 'package:book_list_app/custom/custom_book_details.dart';
import 'package:book_list_app/custom/custom_button.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/stream/update_bookshelf_volumes_class.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class ViewBookDetails extends StatelessWidget {
  final Volume volumeData;

  const ViewBookDetails({
    super.key,
    required this.volumeData,
  });

  @override
  Widget build(BuildContext context) {
    return _ViewBookshelfVolumesStateful(
      volumeData: volumeData
    );
  }
}

class _ViewBookshelfVolumesStateful extends StatefulWidget {
  final Volume volumeData;

  const _ViewBookshelfVolumesStateful({
    required this.volumeData,
  });

  @override
  State<_ViewBookshelfVolumesStateful> createState() => __ViewBookshelfVolumesStatefulState();
}

class __ViewBookshelfVolumesStatefulState extends State<_ViewBookshelfVolumesStateful>{
  late Volume volumeData;
  bool isLoading = true;

  @override
  void initState(){
    super.initState();
    volumeData = widget.volumeData;
    getData();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void getData() async{
    await verifyAccessToken();
    Volume volume = await appState.booksApi!.volumes.get(volumeData.id!);
    appState.globalVolumes[volume.id!] = volume;
    if(mounted){
      setState((){
        isLoading = false;
      });
    }
  }

  void selectBookshelves(){
    showDialog(
      context: context,
      builder: (dialogContext) {
        List<BookshelfCompleteClass> bookshelvesList = [...appState.globalBookshelves[appState.profileData!.id]!.values.toList()];
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
    List<int> combinedList = {...originalList, ...newList}.toList();
    for(int i = 0; i < combinedList.length; i++){
      if(originalList.contains(combinedList[i]) && !newList.contains(combinedList[i])){
        appState.booksApi!.mylibrary.bookshelves.removeVolume(combinedList[i].toString(), volumeData.id!);
        appState.globalBookshelves[appState.profileData!.id]![combinedList[i]]!.volumes.remove(volumeData.id!);
        UpdateBookshelfVolumesStreamClass().emitData(BookshelfVolumesStreamControllerClass(
          combinedList[i]
        ));
      }else if(!originalList.contains(combinedList[i]) && newList.contains(combinedList[i])){
        appState.booksApi!.mylibrary.bookshelves.addVolume(combinedList[i].toString(), volumeData.id!);
        appState.globalBookshelves[appState.profileData!.id]![combinedList[i]]!.volumes.insert(0, volumeData.id!);
        UpdateBookshelfVolumesStreamClass().emitData(BookshelfVolumesStreamControllerClass(
          combinedList[i]
        ));
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Successfully updated!!!')
      )
    );
  }

  @override
  Widget build(BuildContext context){
    if(isLoading || appState.globalVolumes[volumeData.id!] == null){
      return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: defaultAppBarDecoration,
          ),
          title: const Text('Book Details')
        ),
        body: shimmerSkeletonWidget(
          CustomBookDetails(
            volumeData: null, 
            skeletonMode: true,
            key: UniqueKey()
          ),
        ),
        floatingActionButton: shimmerSkeletonWidget(
          FloatingActionButton(
            backgroundColor: Colors.grey,
            onPressed: (){},
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: defaultAppBarDecoration,
        ),
        title: const Text('Book Details')
      ),
      body: CustomBookDetails(
        volumeData: appState.globalVolumes[volumeData.id!]!, 
        skeletonMode: false,
        key: UniqueKey()
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: selectBookshelves,
        child: const Icon(Icons.edit),
      ),
    );
  }
}