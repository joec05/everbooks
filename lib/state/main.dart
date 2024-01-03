import 'package:book_list_app/appdata/private_data.dart';
import 'package:book_list_app/class/bookshelf_complete_class.dart';
import 'package:book_list_app/class/user_auth_tokens_class.dart';
import 'package:book_list_app/class/user_profile_class.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/books/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;

class AppStateClass{
  GoogleSignIn signInConfig;
  auth.AuthClient? client;
  UserAuthTokensClass? tokens;
  UserProfileClass? profileData;
  BooksApi? booksApi;
  Map<String, Map<int, BookshelfCompleteClass>> globalBookshelves;
  Map<String, Volume> globalVolumes;

  AppStateClass(
    this.signInConfig,
    this.client,
    this.tokens,
    this.profileData,
    this.booksApi,
    this.globalBookshelves,
    this.globalVolumes,
  );
}

AppStateClass appState = AppStateClass(
  GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/books'
    ],
    clientId: webClientID,
  ),
  null,
  null,
  null,
  null,
  {},
  {},
);