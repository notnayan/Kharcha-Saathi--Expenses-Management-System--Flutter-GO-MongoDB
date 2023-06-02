// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kharcha_saathi/settings.dart';

class MyTheme extends StatefulWidget {
  const MyTheme({super.key});

  @override
  State<MyTheme> createState() => _MyThemeState();
}

class _MyThemeState extends State<MyTheme> {
  bool isLightMode = false;

  @override
  void initState() {
    super.initState();
    isLightMode = false; // default color scheme is dark
  }

  @override
  Widget build(BuildContext context) {
    Color scaffoldColor = isLightMode ? Colors.white : Colors.black;
    Color appBarColor = const Color(0xFF161341);
    if (isLightMode) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }

    return Scaffold(
      backgroundColor: scaffoldColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MySettings()),
                )),
        title: const Text('Appearance'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              const Text(
                "COLOR SCHEME:",
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 35,
                  color: Color(0xffFB94FD),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Choose the apperance of the application from the two choices provided below. You can always revert the changes if you don't like it.",
                style: TextStyle(
                  fontFamily: "PoppinsLight",
                  fontSize: 15,
                  color: isLightMode ? Colors.black : Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Change Theme'),
                          content: const Text(
                              'Are you sure you want to change the theme?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLightMode = true;
                                });
                                Navigator.pop(context, true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("You have selected light theme."),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ).then((value) {
                        if (value == true) {}
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 170,
                      color: const Color(0xff3E1F52),
                      child: Column(
                        children: [
                          const SizedBox(height: 35),
                          Image.asset(
                            "assets/images/lightmode.png",
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            height: 30,
                            width: 170,
                            color: const Color(0xffFB94FD),
                            child: const Text(
                              "LIGHT",
                              style: TextStyle(
                                fontFamily: "PoppinsBold",
                                fontSize: 25,
                                color: Color(0xff161341),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Change Theme'),
                          content: const Text(
                              'Are you sure you want to change the theme?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('CANCEL'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isLightMode = false;
                                });
                                Navigator.pop(context, true);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("You have selected dark theme."),
                                  ),
                                );
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      ).then((value) {
                        if (value == true) {
                          // change the theme to light theme
                        }
                      });
                    },
                    child: Container(
                      height: 200,
                      width: 170,
                      color: const Color(0xff3E1F52),
                      child: Column(
                        children: [
                          const SizedBox(height: 35),
                          Image.asset(
                            "assets/images/darkmode.png",
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            height: 30,
                            width: 170,
                            color: const Color(0xffFB94FD),
                            child: const Text(
                              "DARK",
                              style: TextStyle(
                                fontFamily: "PoppinsBold",
                                fontSize: 25,
                                color: Color(0xff161341),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
