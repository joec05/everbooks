import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class CustomBasicImage extends StatefulWidget {
  final Volume? volumeData;
  final bool skeletonMode;

  const CustomBasicImage({
    super.key,
    required this.volumeData,
    required this.skeletonMode
  });

  @override
  State<CustomBasicImage> createState() => CustomBasicImageState();
}

class CustomBasicImageState extends State<CustomBasicImage>{

  @override
  Widget build(BuildContext context){
    if(widget.volumeData == null || widget.skeletonMode){
      return Container(
        color: Colors.grey,
        width: (getScreenWidth() - defaultHorizontalPadding * 2) / 5,
        height: getScreenHeight() * 0.16,
      );
    }
    
    Widget unknownItem = GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          NavigationTransition(
            page: ViewBookDetails(
              volumeData: widget.volumeData!,
            )
          )
        );
      },
      child: unknownItemBasicImage
    );

    if(widget.volumeData!.volumeInfo == null){
      return unknownItem;
    }

    if(widget.volumeData!.volumeInfo!.imageLinks == null){
      return unknownItem;
    }
  
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          NavigationTransition(
            page: ViewBookDetails(
              volumeData: widget.volumeData!,
            )
          )
        );
      },
      child: Image.network(
        widget.volumeData!.volumeInfo!.imageLinks!.thumbnail!,
        width: (getScreenWidth() - defaultHorizontalPadding * 2) / 5,
        height: getScreenHeight() * 0.16,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => unknownItem,
      ),
    );
  }
}