// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:kharcha_saathi/settings.dart';

// Defining AboutPage as StatelessWidget
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Create a scaffold with backgroundColor, appBar, and body widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF161341),
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MySettings()),
                )),
        // Set the title of the screen
        title: const Text('About'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Adding a title using Text widget with specified style properties
            Text(
              "Kharcha Saathi",
              style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 40,
                color: Color(0xffFB94FD),
              ),
            ),
            SizedBox(height: 20),
            // Adding a subtitle using Text widget with specified style properties
            Text(
              "'Expenses Management System'",
              style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 21,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            // Adding a brief description using Text widget with specified style properties
            Text(
              "Kharcha Saathi allows you to track your income and expenses in real time. The software organizes your trades and displays them in charts for easy visualization of your financial situation. Rest assured that your financial information is safe and secure with robust security features .",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            // Adding a horizontal divider using Divider widget with specified style properties
            Divider(
              thickness: 2,
              color: Colors.white,
            ),
            // Adding a section title using Text widget with specified style properties
            Text(
              "Features:",
              style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 30,
                color: Color(0xffFB94FD),
              ),
            ),
            SizedBox(height: 10),
            // Adding bullet points using Text widget with specified style properties
            Text(
              "- Real-time expense and income tracking",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            // Adding bullet points using Text widget with specified style properties
            Text(
              "- Graphical display of expenses and income",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            // Adding bullet points using Text widget with specified style properties
            Text(
              "- Advanced security features to protect your financial information",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 5),
            // Adding bullet points using Text widget with specified style properties
            Text(
              "- Systematic display of transactions",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 17,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 11,
            ),
            // Create a centered Text widget
            Center(
              child: Text(
                "--------Thank you for choosing us!--------",
                style: TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontSize: 15,
                  color: Color(0xffFB94FD),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
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
