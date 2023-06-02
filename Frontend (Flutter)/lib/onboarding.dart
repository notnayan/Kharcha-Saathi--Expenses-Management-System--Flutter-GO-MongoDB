//Importing necessary packages and files
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kharcha_saathi/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyApp extends StatefulWidget {
  final bool showHome;

  const MyApp({
    Key? key,
    required this.showHome,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Setting theme data
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 64),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue,
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Setting home screen based on showHome parameter of MyApp class
        home: widget.showHome ? const MyLogin() : const OnboardingScreen(),
      );
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void initState() {
    // Initializing Hive local data box and setting isFirstTime to false
    super.initState();
    var box = Hive.box('localData');
    box.put("isFirstTime", false);
  }

  @override
  void dispose() {
    // Disposing of page controller
    controller.dispose();

    super.dispose();
  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) =>
      Container(
          // Building a container with background color and text
          color: color,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                urlImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: "JetBrainsMono",
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                      color: Colors.white, fontFamily: "PoppinsLight"),
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Building onboarding screen with page view
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 2);
          },
          children: [
            // Building the pages with different content
            buildPage(
                color: const Color.fromARGB(255, 61, 31, 82),
                urlImage: "assets/onboarding/testOB1.png",
                title: "YOOO,I'm your new financial tracking buddy!",
                subtitle:
                    "You are fantastic for taking this initial step toward improving your financial goals and money management."),
            buildPage(
                color: const Color.fromARGB(255, 61, 31, 82),
                urlImage: "assets/onboarding/testOB2.png",
                title: "Manage your spending and start saving today!",
                subtitle:
                    "Manage your expenditures, keep track of your expenses, and ultimately save more money with the aid of Kharcha Saathi."),
            buildPage(
                color: const Color.fromARGB(255, 61, 31, 82),
                urlImage: "assets/onboarding/testOB3.png",
                title: "Together, let's achieve your financial goals!",
                subtitle:
                    "If you don't prepare, you prepare to fail. You can maintain focus on spending tracking and accomplish your financial objectives with the aid of Kharcha Saathi."),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              // A TextButton to get started with the app
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1)),
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(80),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 24, fontFamily: "PoppinsBold"),
              ),
              onPressed: () async {
                // Setting showHome to true in shared preferences and navigating to login screen
                final prefs = await SharedPreferences.getInstance();
                prefs.setBool('showHome', true);

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MyLogin()),
                );
              },
            )
          : Container(
              // A container for the skip and next buttons and the page indicator
              padding: const EdgeInsets.symmetric(horizontal: 1),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // A TextButton to skip to the last page
                  TextButton(
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                            fontFamily: "PoppinsBold",
                            color: Colors.black,
                            fontSize: 22),
                      ),
                      onPressed: () => controller.jumpToPage(2)),
                  Center(
                    // A SmoothPageIndicator to show the current page
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                          spacing: 16,
                          dotColor: Color.fromARGB(255, 22, 19, 65),
                          activeDotColor: Colors.purple),
                      onDotClicked: (index) => controller.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      ),
                    ),
                  ),
                  // A TextButton to go to the next page
                  TextButton(
                      child: const Text(
                        'NEXT',
                        style: TextStyle(
                            fontFamily: "PoppinsBold",
                            color: Colors.black,
                            fontSize: 22),
                      ),
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut)),
                ],
              ),
            ),
    );
  }
}
