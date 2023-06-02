// Import necessary packages
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:kharcha_saathi/about.dart';
import 'package:kharcha_saathi/change_password.dart';
import 'package:kharcha_saathi/help.dart';
import 'package:kharcha_saathi/theme.dart';

// Creating a stateful widget called MySettings
class MySettings extends StatefulWidget {
  const MySettings({super.key});

  // Overriding the createState method to return the _MySettingsState
  @override
  State<MySettings> createState() => _MySettingsState();
}

// Creating the _MySettingsState as a private class
class _MySettingsState extends State<MySettings> {
  @override
  Widget build(BuildContext context) {
    // Returning a Scaffold widget with a black background color, appbar and title
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF161341),
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Adding the current date and time at the top of the screen
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: const TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 15,
                    color: Color(0xFFFB94FD)),
              ),
              const SizedBox(
                height: 12,
              ),
              // Adding a section for General settings
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "General",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 20,
                      color: Color(0xffFB94FD),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Adding an InkWell widget for the Profile settings option
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "This feature will be available in the future build!"),
                  ));
                },
                child: Row(
                  children: [
                    // Adding an icon for the Profile settings option
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF3E1F52)),
                      child: const Icon(
                        Ionicons.person,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // Adding the text for the Profile settings option
                    const Text(
                      "Profile",
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          color: Colors.red,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    // Adding an icon to indicate that the user can navigate to another screen for more options
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              // Adding an InkWell widget for the Appearance settings option
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyTheme()),
                  );
                },
                child: Row(
                  children: [
                    // Adding an icon for the Appearance settings option
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF3E1F52)),
                      child: const Icon(
                        Ionicons.sunny,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Appearance",
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const MyChangePassword()),
                  );
                },
                child: Row(
                  children: [
                    // Adding an icon for the Change Password option
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF3E1F52)),
                      child: const Icon(
                        Ionicons.lock_closed,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Change Password",
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          color: Colors.white,
                          fontSize: 18),
                    ),
                    const Spacer(),
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                children: [
                  Text(
                    "View",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 20,
                      color: Color(0xffFB94FD),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "This feature will be available in the future build!"),
                  ));
                },
                child: Row(
                  children: [
                    // Adding an icon for the currency option
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF3E1F52)),
                      child: const Icon(
                        Ionicons.cash,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Currency",
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          color: Colors.red,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      width: 120,
                    ),
                    const Row(
                      children: [
                        Text(
                          "NPR",
                          style: TextStyle(
                              fontFamily: "PoppinsBold",
                              color: Colors.red,
                              fontSize: 20),
                        )
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "This feature will be available in the future build!"),
                  ));
                },
                child: Row(
                  children: [
                    // Adding an icon for the language option
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: const Color(0xFF3E1F52)),
                      child: const Icon(
                        Ionicons.language,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    const Text(
                      "Language",
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          color: Colors.red,
                          fontSize: 18),
                    ),
                    const SizedBox(
                      width: 115,
                    ),
                    const Row(
                      children: [
                        Text(
                          "ENG",
                          style: TextStyle(
                              fontFamily: "PoppinsBold",
                              color: Colors.red,
                              fontSize: 20),
                        )
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Creating a new InkWell widget to show a SnackBar when tapped
              InkWell(
                onTap: () {
                  // Displaying a SnackBar with a message when the InkWell is tapped
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "This feature will be available in the future build!"),
                  ));
                },
                child: const Row(
                  children: [
                    // Displaying text "App" in a Row
                    Text(
                      "App",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 20,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
              ),

              // Adding some empty space
              const SizedBox(
                height: 20,
              ),

              // Creating a new InkWell widget to navigate to the MyHelp page when tapped
              InkWell(
                onTap: () {
                  // Navigating to the MyHelp page when the InkWell is tapped
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyHelp()),
                  );
                },
                child: Row(
                  children: [
                    // Displaying an icon inside a Container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF3E1F52),
                      ),
                      child: const Icon(
                        Ionicons.help_circle,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // Displaying text "Help" next to the icon
                    const Text(
                      "Help",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    // Displaying a chevron icon at the end of the Row
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),

              // Adding some empty space
              const SizedBox(
                height: 12,
              ),

              // Creating a new InkWell widget to navigate to the AboutPage when tapped
              InkWell(
                onTap: () {
                  // Navigating to the AboutPage when the InkWell is tapped
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
                child: Row(
                  children: [
                    // Displaying an icon inside a Container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF3E1F52),
                      ),
                      child: const Icon(Ionicons.star, color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    // Displaying text "About Us" next to the icon
                    const Text(
                      "About Us",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    // Displaying a chevron icon at the end of the Row
                    const Icon(
                      Ionicons.chevron_forward_outline,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
