import 'dart:io';
import 'package:book_list_app/appdata/global_functions.dart';
import 'package:book_list_app/class/user_auth_tokens_class.dart';
import 'package:book_list_app/class/user_profile_class.dart';
import 'package:book_list_app/main_page.dart';
import 'package:book_list_app/state/main.dart';
import 'package:book_list_app/styles/app_styles.dart';
import 'package:book_list_app/transition/navigation_transition.dart';
import 'package:http/http.dart' as http;
import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/books/v1.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  ByteData data = await PlatformAssetBundle().load('assets/certificate/ca.pem');
  SecurityContext.defaultContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Everbooks',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Everbooks Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AssetImage assetImage = const AssetImage('assets/images/icon.png');

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), (){
      obtainCredentials();
    });
  }

  Future<void> obtainCredentials() async {
    if(!await appState.signInConfig.isSignedIn()){
      await appState.signInConfig.signIn();
    }else{
      await appState.signInConfig.signInSilently(
        reAuthenticate: true
      );
    }
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
      if(mounted){
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

  @override
  Widget build(BuildContext context) {
    precacheImage(assetImage, context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: defaultAppBarDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: assetImage,
              width: getScreenWidth() * 0.4, 
              height: getScreenWidth() * 0.4
            ),
          ],
        )
      )
    );
  }
}
