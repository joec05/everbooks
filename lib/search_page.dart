import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/appdata/global_variables.dart';
import 'package:book_list_app/custom/custom_book_row_display.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:googleapis/books/v1.dart';

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
  TextEditingController searchController = TextEditingController();
  ValueNotifier<String> searchedText = ValueNotifier('');
  ValueNotifier<bool> verifySearchedFormat = ValueNotifier(false);
  List<String> searchedBooks = [];
  FocusNode focusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void search() async{
    if(searchController.text.isNotEmpty){
      if(mounted){
        setState(() => isLoading = true);
      }
      focusNode.unfocus();
      await verifyAccessToken();
      Volumes searchedVolumes = await appState.booksApi!.volumes.list(
        searchController.text,
        maxResults: 25,
        orderBy: 'relevance'
      );
      if(searchedVolumes.items != null){
        for(int i = 0; i < searchedVolumes.items!.length; i++){
          Volume volume = searchedVolumes.items![i];
          if(volume.id != null){
            appState.globalVolumes[volume.id!] = volume;
          }
        }
        if(mounted){
          setState((){
            searchedBooks = searchedVolumes.items!.map((e) => e.id as String).toList();
            isLoading = false;
          });
        }
      }else{
        if(mounted){
          setState((){
            searchedBooks = [];
            isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        titleSpacing: getScreenWidth() * 0.015,
        title: ValueListenableBuilder(
          valueListenable: verifySearchedFormat,
          builder: (context, allowPress, child){
            return TextField(
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              onEditingComplete: search,
              controller: searchController,
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
                  onPressed: () => searchController.text = '',
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
            );
          }
        ),
      ),
      body: ListView.builder(
        itemCount: isLoading ? defaultShimmerLength : searchedBooks.length,
        itemBuilder: (context, index){
          if(isLoading){
            return shimmerSkeletonWidget(
              const CustomBookRowDisplay(
                volumeData: null, 
                skeletonMode: true
              ),
            );
          }
          return CustomBookRowDisplay(
            volumeData: appState.globalVolumes[searchedBooks[index]], 
            key: UniqueKey(),
            skeletonMode: false
          );
        },
      )
    );
  }
}