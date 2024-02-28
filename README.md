# Everbooks

A reading tracker Flutter application powered by Google Books API. 

## Getting Started

Login to Google Cloud and create a new application. Name it however you like. Then activate Google Books API in the 'Enabled API and Services' section.

Next, go to 'Credentials' section then click 'Create Credentials' then click 'OAuth client ID'. You will then be directed to a page where you can choose the application type for the client ID. Now, select 'Web application'. Then name it whatever you like. Then click create.

Next, you need to generate the SHA1 fingerprint for your app's debug and release mode and declare it in your app level build.gradle. Follow my StackOverflow [answer]("https://stackoverflow.com/questions/77748198/flutter-firebase-google-sign-in-error-i-flutter-5171-platformexceptionsi/77749581#77749581") for more information.

Once you manage to get the SHA1 fingerprint key for the debug and release mode, go back to the 'Credentials' section of your application in Google Cloud then add again a new OAuth client ID, but this time select the application type to Android. Again, you can name it whatever you want, then it will also ask for the package name, which you can get in the `android/app/build.gradle` file, and a SHA1 fingerprint. Paste the debug SHA1 key. Then click create. After that, repeat the above steps, but this time paste the release SHA1 key instead.

Once you finished creating a total of 3 credentials (3 OAuth client IDs), create a new file called `private_data.dart` in `lib/appdata` directory. Then paste this code and modify accordingly.

`String webClientID = 'YOUR-WEB-CLIENT-ID';`

You will need to replace 'YOUR-WEB-CLIENT-ID' with the web application's OAuth client ID.

Please note that while the ids for the OAuth Android clients aren't used directly by the app, removing them will throw an error when signing in with Google.

## Features

* Retrieve all the bookshelves and their information (name, date created, date updated, amount of items, and description)

* Retrieve all the books in each bookshelves

* Basic details of each book

* Add and remove books to and from bookshelves

* Search for books

## Download app

Currently on pending

## Everbooks in display

![Everbooks demo 1](https://github.com/joec05/files/blob/main/gbook_client/demo_1.png?raw=true "Everbooks demo 1")
