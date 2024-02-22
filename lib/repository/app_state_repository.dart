import 'package:book_list_app/global_files.dart';
import 'package:googleapis/books/v1.dart';

class AppStateClass{
  BooksApi? booksApi;
  Map<String, Map<int, BookshelfCompleteClass>> globalBookshelves = {};
  Map<String, Volume> globalVolumes = {};
}

AppStateClass appStateRepo = AppStateClass();