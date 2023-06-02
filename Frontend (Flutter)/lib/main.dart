// Importing necessary packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kharcha_saathi/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Main function, entry point for the app
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Initializes the necessary bindings for the app to run
  await Firebase.initializeApp(); // Initializes Firebase
  await Hive.initFlutter(); // Initializes Hive for Flutter
  await Hive.openBox("localData"); // Opens the Hive box for local data
  await Hive.openBox("userData"); // Opens the Hive box for user data
  var box = Hive.box('localData'); // Gets the Hive box for local data

  if (box.get("isFirstTime") == null) {
    box.put("isFirstTime",
        true); // Sets the "isFirstTime" key in the local data Hive box to true if it doesn't already exist
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Removing debug banner
    initialRoute: "splash", // Setting initial route to splash screen

    routes: {
      // Defining a map of route names and builder functions
      "splash": (context) =>
          const Splashscreen() // Associating "splash" route with Splashscreen widget
    },
  ));
}
