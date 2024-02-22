import 'package:book_list_app/global_files.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SearchPageWidget extends StatelessWidget {
  const SearchPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MainPageWidgetStateful();
  }
}

class _MainPageWidgetStateful extends StatefulWidget {
  const _MainPageWidgetStateful();

  @override
  State<_MainPageWidgetStateful> createState() => __MainPageWidgetStatefulState();
}

class __MainPageWidgetStatefulState extends State<_MainPageWidgetStateful>{
  late SearchPageController controller;

  @override
  void initState(){
    super.initState();
    controller = SearchPageController(context);
    controller.initializeController();
  }

  @override
  void dispose(){
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        titleSpacing: getScreenWidth() * 0.015,
        title:  TextField(
          focusNode: controller.focusNode,
          textInputAction: TextInputAction.search,
          onEditingComplete: controller.search,
          controller: controller.searchController,
          maxLines: 1,
          maxLength: 30,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.symmetric(horizontal: getScreenWidth() * 0.025),
            fillColor: Colors.transparent,
            filled: true,
            hintText: 'Search anything',
            prefixIcon: const Icon(
              FontAwesomeIcons.magnifyingGlass, 
              size: 17.5, 
            ),
            suffixIcon: TextButton(
              onPressed: () => controller.searchController.text = '',
              child: const Icon(
                FontAwesomeIcons.xmark,
                size: 17.5
              ),
            ),
            constraints: BoxConstraints(
              maxWidth: getScreenWidth() * 0.8,
              maxHeight: getScreenHeight() * 0.07,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
              borderRadius: BorderRadius.circular(12.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white.withOpacity(0.75), width: 2),
              borderRadius: BorderRadius.circular(12.5),
            ),
          )
        )
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          controller.isLoading,
          controller.searchedBooks
        ]),
        builder: (context, child) {
          bool isLoadingValue = controller.isLoading.value;
          List<String> searchedBooks = controller.searchedBooks.value;
          return ListView.builder(
            itemCount: isLoadingValue ? defaultShimmerLength : searchedBooks.length,
            itemBuilder: (context, index){
              if(isLoadingValue){
                return shimmerSkeletonWidget(
                  const CustomBookRowDisplay(
                    volumeData: null, 
                    skeletonMode: true
                  ),
                );
              }
              return CustomBookRowDisplay(
                volumeData: appStateRepo.globalVolumes[searchedBooks[index]], 
                key: UniqueKey(),
                skeletonMode: false
              );
            },
          );
        }
      )
    );
  }
}