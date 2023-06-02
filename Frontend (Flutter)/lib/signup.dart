// Importing necessary packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kharcha_saathi/choose_Currency.dart';
import 'package:kharcha_saathi/login.dart';
import 'package:kharcha_saathi/signup_email.dart';

// Define a StatefulWidget called Mysignup
class Mysignup extends StatefulWidget {
  const Mysignup({super.key});

  @override
  State<Mysignup> createState() => _MysignupState();
}

// Define the state for the Mysignup widget
class _MysignupState extends State<Mysignup> {
  var box = Hive.box('userData');
  late GoogleSignIn _googleSignIn;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Return a container with a background image decoration and a scaffold
    return Container(
      // Background image decoration
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/signup.png"), fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Container(
                    // Column of sign-up options
                    padding: const EdgeInsets.only(left: 45, top: 425),
                    child: Column(
                      children: [
                        const Text(
                          "Sign Up below and take a \n step towards your goal!",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "JetBrainsMono",
                              fontSize: 21),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        ElevatedButton.icon(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              signInWithGoogle(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    fontFamily: "JetBrainsMono", fontSize: 20)),
                            icon: const FaIcon(FontAwesomeIcons.google),
                            label: const Text("CONNECT WITH GOOGLE")),
                        const SizedBox(
                          height: 32,
                        ),
                        ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MySignupEmail()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                textStyle: const TextStyle(
                                    fontFamily: "JetBrainsMono", fontSize: 20)),
                            icon: const FaIcon(FontAwesomeIcons.solidEnvelope),
                            label: const Text("SIGN UP WITH EMAIL")),
                      ],
                    ),
                  ),
                  Container(
                    // Login link at the bottom
                    padding: const EdgeInsets.only(left: 35, top: 650),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontFamily: "JetBrainsMono"),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const MyLogin()),
                              );
                            },
                            child: const Text("LOG IN",
                                style: TextStyle(
                                    fontFamily: "JetBrainsMono",
                                    fontSize: 14,
                                    color: Color(0xff0000EE)))),
                      ],
                    ),
                  ),
                  Container(
                    // Terms of service text at the very bottom
                    padding: const EdgeInsets.only(top: 725),
                    child: const Text(
                      "By signing up or connecting with the services above you agree to our Terms of Services and acknowledge our Privacy Policy describing how we handle your personal data.",
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 12,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

signInWithGoogle(BuildContext context) async {
  // Sign out the current user, if any
  await GoogleSignIn().signOut();
  try {
    // Sign in with Google
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Get the authentication details
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create an AuthCredential object
    AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

    // Sign in to Firebase with the AuthCredential
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Navigate to the 'Mycurrency' page
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const Mycurrency(
        accessToken: '',
      ),
    ));
  } catch (e) {
    // Print any errors that occur
    print(e.toString());
  }
}
