import 'dart:math';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:book_list_app/class/user_auth_tokens_class.dart';
import 'package:book_list_app/class/user_profile_class.dart';
import 'package:book_list_app/state/main.dart';
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:googleapis/books/v1.dart';

double getScreenHeight(){
  return PlatformDispatcher.instance.views.first.physicalSize.height / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

double getScreenWidth(){
  return PlatformDispatcher.instance.views.first.physicalSize.width / PlatformDispatcher.instance.views.first.devicePixelRatio;
}

Future<void> verifyAccessToken() async{
  await appState.signInConfig.currentUser!.clearAuthCache().then((_) async{
    await appState.signInConfig.signInSilently().then((_) async{
      await appState.signInConfig.authenticatedClient().then((value){
        appState.client = value;
        appState.tokens = appState.client == null ? null : UserAuthTokensClass(
          appState.client!.credentials.accessToken.data,
          appState.client!.credentials.accessToken.expiry.toIso8601String(),
          appState.client!.credentials.idToken ?? '',
          appState.client!.credentials.refreshToken ?? ''
        );
        appState.profileData = appState.signInConfig.currentUser == null ? null : UserProfileClass(
          appState.signInConfig.currentUser!.id,
          appState.signInConfig.currentUser!.displayName ?? '',
          appState.signInConfig.currentUser!.email,
          appState.signInConfig.currentUser!.photoUrl ?? ''
        );
        appState.booksApi = BooksApi(appState.client as http.Client);
        return;
      });
    });
  });
}

String createCodeVerifier(){
  String codeVerifier = '';
  String alphabets = 'abcdefghijklmnopqrstuvwxyz';
  List<String> allowedChars = [];
  allowedChars.addAll(alphabets.split(''));
  allowedChars.addAll(alphabets.toUpperCase().split(''));
  allowedChars.addAll(["-", ".", "_", "~", ...'0123456789'.split('')]);
  while(codeVerifier.length < 128){
    codeVerifier = '$codeVerifier${allowedChars[Random().nextInt(allowedChars.length)]}';
  }
  return codeVerifier;
}

String convertDateTimeDisplay(String dateTime){
  if(DateTime.tryParse(dateTime) == null){
    if(dateTime.length == 4){
      return dateTime;
    }else{
      return '?';
    }
  }
  List<String> separatedDateTime = DateTime.parse(dateTime).toLocal().toIso8601String().substring(0, 10).split('-').reversed.toList();
  List<String> months = [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ];
  separatedDateTime[1] = months[int.parse(separatedDateTime[1])];
  return separatedDateTime.join(' ');
}