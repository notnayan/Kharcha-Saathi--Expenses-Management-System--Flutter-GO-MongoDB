// Importing necessary packages

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kharcha_saathi/settings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//StatefulWidget for changing password
class MyChangePassword extends StatefulWidget {
  const MyChangePassword({super.key});

  @override
  State<MyChangePassword> createState() => _MyChangePasswordState();
}

class _MyChangePasswordState extends State<MyChangePassword> {
  //creating two text controllers to retrieve user's input
  final TextEditingController opassController = TextEditingController();
  final TextEditingController npassController = TextEditingController();
  //boolean variable to indicate loading state
  bool isLoading = false;
  //boolean variable to toggle password visibility
  bool _isObscure = true;
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  var box = Hive.box('userData');

  @override
  void dispose() {
    //disposing the text controllers
    opassController.dispose();
    npassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //getting the user's access token from the database
    String accessToken = box.get("accessToken");
    //creating a scaffold widget with a black background and appbar
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF161341),
        //creating back button to navigate back to settings page
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const MySettings()),
                )),
        title: const Text('Change Password'),
      ),
      //loading state management using ternary operator
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "CHANGE\nPASSWORD",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 35,
                          color: Color(0xffFB94FD),
                        ),
                      ),
                      const Text(
                        "Set up your account with a strong password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Row containing a title for the password requirements
                      const Row(
                        children: [
                          Text(
                            "Your password must:",
                            style: TextStyle(
                              fontFamily: "PoppinsBold",
                              fontSize: 20,
                              color: Color(0xffFB94FD),
                            ),
                          ),
                        ],
                      ),
                      // Column containing the password requirements
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 2,
                          ),
                          const Text(
                            "1. Use a minimum of 8 characters.",
                            style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "2. Use combination of uppercase and lowercase letters, numbers, and symbols.",
                            style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Current Password:",
                            style: TextStyle(
                              fontFamily: "PoppinsBold",
                              fontSize: 20,
                              color: Color(0xffFB94FD),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // A TextFormField for the current password field
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              // Regular expression to validate password
                              RegExp passReg = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              // Check if value matches password regex
                              if (!passReg.hasMatch(value.toString())) {
                                return "Invalid Password";
                              }
                              return null;
                            },
                            obscureText: _isObscure,
                            controller: opassController,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              labelText: "Current Password",
                              labelStyle: const TextStyle(color: Colors.white),
                              hintText: 'Enter your current password',
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "New Password:",
                            style: TextStyle(
                              fontFamily: "PoppinsBold",
                              fontSize: 20,
                              color: Color(0xffFB94FD),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // Validate new password field
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              RegExp passReg = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              // Check if value matches password regex
                              if (!passReg.hasMatch(value.toString())) {
                                return "Invalid Password";
                              }
                              return null;
                            },
                            obscureText: _isObscure,
                            controller: npassController,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255)),
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                                child: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 2.0,
                                ),
                              ),
                              labelText: "New Password",
                              labelStyle: const TextStyle(color: Colors.white),
                              hintText: 'Enter your new password',
                              hintStyle: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          // Submit button
                          ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              // Send patch request to update user's password
                              http.Response response = await http.patch(
                                  Uri.parse(
                                      "https://kharchasathi-backend.onrender.com/users/password"),
                                  headers: {
                                    "Authorization": 'Bearer $accessToken'
                                  },
                                  body: json.encode(
                                    {
                                      "OldPassword": opassController
                                          .text, // value of old password entered by user
                                      "NewPassword": npassController
                                          .text // value of new password entered by user
                                    },
                                  ));

                              var jsonResponse = json.decode(response.body);
                              // if response status code is 200, show success message, navigate to MySettings screen and replace current screen with it
                              if (response.statusCode == 200) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(jsonResponse["message"]),
                                ));
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const MySettings()),
                                );
                              }
                              // if response status code is not 200, show error message
                              else {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(jsonResponse["error"]),
                                ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff3E1F52),
                            ),
                            child: const Text(
                              "CONFIRM",
                              style: TextStyle(fontFamily: "PoppinsBold"),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
