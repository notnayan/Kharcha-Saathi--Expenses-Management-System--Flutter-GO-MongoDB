// Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kharcha_saathi/dashboard.dart';
import 'package:kharcha_saathi/login.dart';
import 'package:kharcha_saathi/onboarding.dart';
import 'package:lottie/lottie.dart';

// Defining a stateful widget for the splash screen
class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

// Defining the state for the splash screen
class _SplashscreenState extends State<Splashscreen> {
  // This method is called when the state is initialized
  @override
  void initState() {
    // Scheduling a delay of 4 seconds before navigating to the login page
    Future.delayed(const Duration(seconds: 4), () {
      var box = Hive.box('localData');
      var accessTokenBox = Hive.box('userData');

      bool isFirsttime = box.get("isFirstTime");
      String? accessToken = accessTokenBox.get("accessToken");

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => isFirsttime
                ? const OnboardingScreen()
                : accessToken == null
                    ? const MyLogin()
                    : MyDashboard(accessToken: accessToken),
          ));
    });
    super.initState();
  }

  // This method builds the splash screen widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFF3E1F52),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Displaying a Lottie animation of a wallet
              SizedBox(
                height: 300,
                width: 300,
                child: Lottie.asset("assets/splash/wallet.json"),
              ),
              const SizedBox(height: 20),
              // Displaying the app name
              const Text(
                "Kharcha Saathi",
                style: TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 30,
                    color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
