import 'package:book_list_app/global_files.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/books/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth show AuthClient;
import 'package:http/http.dart' as http;

class AuthenticationRepository {
  GoogleSignIn signInConfig = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/books'
    ],
    clientId: webClientID,
  );
  auth.AuthClient? client;
  UserAuthTokensClass? tokens;
  UserProfileClass? profileData;

  Future<void> obtainCredentials(BuildContext context) async {
    if(!await authRepo.signInConfig.isSignedIn()){
      await authRepo.signInConfig.signIn();
    }else{
      await authRepo.signInConfig.signInSilently(
        reAuthenticate: true
      );
    }
    await authRepo.signInConfig.authenticatedClient().then((value){
      authRepo.client = value;
      authRepo.tokens = authRepo.client == null ? null : UserAuthTokensClass(
        authRepo.client!.credentials.accessToken.data,
        authRepo.client!.credentials.accessToken.expiry.toIso8601String(),
        authRepo.client!.credentials.idToken ?? '',
        authRepo.client!.credentials.refreshToken ?? ''
      );
      authRepo.profileData = authRepo.signInConfig.currentUser == null ? null : UserProfileClass(
        authRepo.signInConfig.currentUser!.id,
        authRepo.signInConfig.currentUser!.displayName ?? '',
        authRepo.signInConfig.currentUser!.email,
        authRepo.signInConfig.currentUser!.photoUrl ?? ''
      );
      appStateRepo.booksApi = BooksApi(authRepo.client as http.Client);
      if(context.mounted){
        Navigator.pushAndRemoveUntil(
          context,
          NavigationTransition(
            page: const MainPageWidget()
          ),
          (Route<dynamic> route) => false
        );
      }
      return;
    });
  }

  Future<void> verifyAccessToken(BuildContext context) async{
    try {
      await authRepo.signInConfig.currentUser!.clearAuthCache().then((_) async{
        await authRepo.signInConfig.signInSilently().then((_) async{
          await authRepo.signInConfig.authenticatedClient().then((value){
            authRepo.client = value;
            authRepo.tokens = authRepo.client == null ? null : UserAuthTokensClass(
              authRepo.client!.credentials.accessToken.data,
              authRepo.client!.credentials.accessToken.expiry.toIso8601String(),
              authRepo.client!.credentials.idToken ?? '',
              authRepo.client!.credentials.refreshToken ?? ''
            );
            authRepo.profileData = authRepo.signInConfig.currentUser == null ? null : UserProfileClass(
              authRepo.signInConfig.currentUser!.id,
              authRepo.signInConfig.currentUser!.displayName ?? '',
              authRepo.signInConfig.currentUser!.email,
              authRepo.signInConfig.currentUser!.photoUrl ?? ''
            );
            appStateRepo.booksApi = BooksApi(authRepo.client as http.Client);
            return;
          });
        });
      });
    } catch (_) {
      if(context.mounted) {
        handler.displaySnackbar(
          context, 
          SnackbarType.error, 
          tErr.api
        );
        return;
      }
    }
  }
}

final AuthenticationRepository authRepo = AuthenticationRepository();