// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kharcha_saathi/settings.dart';

// Class for Help Screen
class MyHelp extends StatelessWidget {
  const MyHelp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color of the screen
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Set the color of app bar
        backgroundColor: const Color(0xFF161341),
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MySettings()),
                )),
        // Set the title of the screen
        title: const Text('Help'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  children: [
                    // Title of the section
                    Text(
                      "Information",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 25,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                const Column(
                  children: [
                    // Description of the section
                    Text(
                      "This is a work in progress application. We intend to add new features so come join the BETA team.",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color(0xffFB94FD),
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the section
                    Text(
                      "Feedback",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 25,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                const Column(
                  children: [
                    // Description of the section
                    Text(
                      "Your feedback is immensely valuable for us to make this application successful. This app is for the community so a small tip can go a long way.",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color(0xffFB94FD),
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the section
                    Text(
                      "Bugs & Glitches",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 25,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                const Column(
                  children: [
                    // Description of the section
                    Text(
                      "We’re extremely sorry in advance in case of any trouble. Please contact us and we’ll resolve it asap.",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color(0xffFB94FD),
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the section
                    Text(
                      "Contact",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 25,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Description of the section
                  children: [
                    Text(
                      "For assistance please contact us during business hours!",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Email: kharchasaathi69420@gmail.com",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "Phone: +977 9800069420",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Color(0xffFB94FD),
                  thickness: 1,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title of the section
                    Text(
                      "Links",
                      style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 25,
                        color: Color(0xffFB94FD),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 2,
                ),
                const Column(
                  children: [
                    // Description of the section
                    Text(
                      "Please make sure to give us a follow on the accounts provided below :)",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.facebook,
                          color: Color(0xFFFB94FD),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.github,
                          color: Color(0xFFFB94FD),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.instagram,
                          color: Color(0xFFFB94FD),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.linkedin,
                          color: Color(0xFFFB94FD),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.twitter,
                          color: Color(0xFFFB94FD),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      // Create a BottomAppBar widget that displays version information.
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 25,
          color: const Color(0xff161341),
          child: const Center(
            child: Text(
              "Version 0.6.9",
              style: TextStyle(fontFamily: "PoppinsBold", color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
