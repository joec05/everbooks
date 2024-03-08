import 'dart:ui';
import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/books/v1.dart';

class CustomBookDetails extends StatefulWidget {
  final Volume? volumeData;
  final bool skeletonMode;

  const CustomBookDetails({
    super.key,
    required this.volumeData,
    required this.skeletonMode
  });

  @override
  State<CustomBookDetails> createState() => CustomBookDetailsState();
}

class CustomBookDetailsState extends State<CustomBookDetails>{
  late Volume? volumeData;

  @override
  void initState(){
    super.initState();
    volumeData = widget.volumeData;
  }

  @override
  void dispose(){
    super.dispose();
  }

  ImageProvider? generatePosterImage(){
    String link = '';
    VolumeVolumeInfoImageLinks? imgLinks = volumeData!.volumeInfo!.imageLinks;
    if(imgLinks == null) {
      return null;
    }
    if(imgLinks.extraLarge != null){
      link = imgLinks.extraLarge!;
    }else if(imgLinks.large != null){
      link = imgLinks.large!;
    }else if(imgLinks.medium != null){
      link = imgLinks.medium!;
    }else if(imgLinks.small != null){
      link = imgLinks.small!;
    }else if(imgLinks.thumbnail != null){
      link = imgLinks.thumbnail!;
    }else if(imgLinks.smallThumbnail != null){
      link = imgLinks.smallThumbnail!;
    }else{
      return unknownItemPosterImage;
    }
    
    ImageProvider provider = NetworkImage(link);
    return provider;
  }

  @override
  Widget build(BuildContext context){
    if(widget.skeletonMode){
      return ListView(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: getScreenHeight() * 0.4,
                color: Colors.grey
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: defaultVerticalPadding,
                  horizontal: defaultHorizontalPadding
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: getScreenHeight() * 0.01
                    ),
                    Container(
                      width: double.infinity,
                      height: getScreenHeight() * 0.1,
                      color: Colors.grey                 
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.04
                    ),
                    Container(
                      width: double.infinity,
                      height: getScreenHeight() * 0.45,
                      color: Colors.grey                 
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.04
                    ),
                    Container(
                      width: double.infinity,
                      height: getScreenHeight() * 0.15,
                      color: Colors.grey                 
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    ),
                    Container(
                      width: double.infinity,
                      height: getScreenHeight() * 0.15,
                      color: Colors.grey                 
                    ),
                    SizedBox(
                      height: getScreenHeight() * 0.025
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      );
    }
    
    List<String> categories = [];
    ImageProvider? poster;
    if(volumeData!.volumeInfo != null && volumeData!.volumeInfo!.categories != null) {
      for(int i = 0; i < volumeData!.volumeInfo!.categories!.length; i++){
        String category = volumeData!.volumeInfo!.categories![i];
        if(category.contains('/')){
          List<String> subCategories = category.split('/');
          categories.addAll(subCategories.map((e) => e.trim()).toList());
        }else{
          categories.add(category);
        }
      }
      categories = categories.toSet().toList();
      poster = generatePosterImage();
      if(poster != null) {
        precacheImage(poster, context);
      }
    }
    
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: getScreenHeight() * 0.4,
              decoration: BoxDecoration(
                image: volumeData!.volumeInfo!.imageLinks != null && volumeData!.volumeInfo!.imageLinks!.smallThumbnail != null ?
                  DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      volumeData!.volumeInfo!.imageLinks!.thumbnail ?? volumeData!.volumeInfo!.imageLinks!.smallThumbnail!,
                    )
                  )
                :
                  DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      unknownItemLink
                    )
                  )
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.5, sigmaY: 7.5),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.0)),
                      ),
                    ),
                  ),
                  Center(
                    child: poster != null ? 
                      Image(
                        image: poster,
                        width: getScreenWidth() * 0.4,
                        height: getScreenHeight() * 0.35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          unknownItemLink,
                          width: getScreenWidth() * 0.4,
                          height: getScreenHeight() * 0.35,
                          fit: BoxFit.cover,
                        ),
                      )
                    :
                      Image.asset(
                        unknownItemLink,
                        width: getScreenWidth() * 0.4,
                        height: getScreenHeight() * 0.35,
                        fit: BoxFit.cover,
                      )
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(
                vertical: defaultVerticalPadding,
                horizontal: defaultHorizontalPadding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getScreenHeight() * 0.01
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            children: [
                              TextSpan(
                                text: volumeData!.volumeInfo!.title!,
                                style: const TextStyle(
                                  fontSize: 17.5,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              TextSpan(
                                text: ' by ${volumeData!.volumeInfo!.authors != null ? volumeData!.volumeInfo!.authors!.join(', ') : '?'}',
                                style: const TextStyle(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 104, 102, 102)
                                ),
                              ),
                            ]
                          )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.04
                  ),
                  Text(
                    volumeData!.volumeInfo!.description ?? 'No synopsis found',
                    style: TextStyle(
                      fontSize: 15,
                      fontStyle: volumeData!.volumeInfo!.description != null ? FontStyle.normal : FontStyle.italic
                    )
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.04
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      Wrap(
                        children: [
                          for(int i = 0; i < categories.length; i++)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: getScreenWidth() * 0.02,
                              vertical: getScreenHeight() * 0.005
                            ),
                            margin: EdgeInsets.only(
                              right: getScreenWidth() * 0.015,
                              bottom: getScreenHeight() * 0.0075
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 40, 78, 97),
                              borderRadius: BorderRadius.all(Radius.circular(10))
                            ),
                            child: Text(categories[i])
                          )
                        ]
                      )
                    ]
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.025
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Publish Info',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(
                        height: getScreenHeight() * 0.01
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenWidth() * 0.03,
                          vertical: getScreenHeight() * 0.0075
                        ),
                        margin: EdgeInsets.only(
                          bottom: getScreenHeight() * 0.01
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 28, 102, 98),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(
                          'Published by ${volumeData!.volumeInfo!.publisher ?? '?'}'
                        )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: getScreenWidth() * 0.03,
                          vertical: getScreenHeight() * 0.0075
                        ),
                        margin: EdgeInsets.only(
                          bottom: getScreenHeight() * 0.01
                        ),
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 28, 102, 98),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Text(
                          'Published at ${volumeData!.volumeInfo!.publishedDate != null ? convertDateTimeDisplay(volumeData!.volumeInfo!.publishedDate!) : '?'}'
                        )
                      )
                    ]
                  ),
                  SizedBox(
                    height: getScreenHeight() * 0.025
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}