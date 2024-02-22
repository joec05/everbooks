import 'package:book_list_app/global_files.dart';
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
  late BookDetailsController controller;

  @override
  void initState(){
    super.initState();
    volumeData = widget.volumeData;
    controller = BookDetailsController(context, volumeData);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return ValueListenableBuilder(
      valueListenable: controller.isLoading,
      builder: (context, isLoadingValue, child) {
        
        if(isLoadingValue || appStateRepo.globalVolumes[volumeData.id!] == null){
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
            volumeData: appStateRepo.globalVolumes[volumeData.id!]!, 
            skeletonMode: false,
            key: UniqueKey()
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: controller.selectBookshelves,
            child: const Icon(Icons.edit),
          ),
        );
      }
    );
  }
}