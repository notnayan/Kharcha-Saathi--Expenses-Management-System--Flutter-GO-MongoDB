// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:kharcha_saathi/login.dart';
import 'package:kharcha_saathi/signup.dart';
import 'package:http/http.dart' as http;

// Define a StatefulWidget called MysignupEmail
class MySignupEmail extends StatefulWidget {
  const MySignupEmail({super.key});

  @override
  State<MySignupEmail> createState() => _MySignupEmailState();
}

class _MySignupEmailState extends State<MySignupEmail> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true;
  var box = Hive.box('userData');
  final GlobalKey<FormState> form = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //The container is used to provide a background image for the page.
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/emailsignup.png"),
              fit: BoxFit.fill)),
      child: Scaffold(
        //The background color of the scaffold is transparent to show the background image.
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 17, top: 425),
                        child: const Text(
                          "Sign Up using your email",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: "JetBrainsMono"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.62,
                            right: 35,
                            left: 35),
                        child: Form(
                          key: form,
                          child: Column(
                            children: [
                              //This TextFormField is used to take email input from the user.
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  RegExp emailReg = RegExp(
                                      //This TextFormField is used to take email input from the user.
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                                  if (!emailReg.hasMatch(value.toString())) {
                                    return "Invalid Email";
                                  }
                                  return null;
                                },
                                controller: emailController,
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 2.0),
                                    ),
                                    labelText: "Email",
                                    labelStyle: TextStyle(color: Colors.white),
                                    hintText: 'Enter your email',
                                    hintStyle: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              //This TextFormField is used to take password input from the user.
                              TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  //This regex is used to validate the password.
                                  RegExp passReg = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (!passReg.hasMatch(value.toString())) {
                                    return "Invalid Password";
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                obscureText: _isObscure,
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
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          width: 2.0),
                                    ),
                                    labelText: "Password",
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                    hintText: 'Enter your password',
                                    hintStyle:
                                        const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              // Creating an ElevatedButton to submit the form
                              ElevatedButton(
                                onPressed: () async {
                                  if (form.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    http.Response response = await http.post(
                                        Uri.parse(
                                            // Sending a POST request to create a new user
                                            "https://kharchasathi-backend.onrender.com/users"),
                                        headers: {
                                          "Authorization":
                                              "Bearer ${box.get("accessToken")}"
                                        },
                                        body: json.encode({
                                          "email": emailController.text,
                                          "password": passwordController.text
                                        }));

                                    var jsonResponse =
                                        json.decode(response.body);
                                    if (response.statusCode == 200) {
                                      // Displaying a success message and navigating to the login screen
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(jsonResponse["message"]),
                                      ));

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyLogin()),
                                      );
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text(jsonResponse["error"]),
                                      ));
                                    }
                                  }
                                },
                                // Styling the ElevatedButton
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: "JetBrainsMono")),
                                child: const Text('SIGN UP'),
                              ),
                              // Creating a row with a Text and a TextButton to navigate to the login screen
                              Row(
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            "Account created successfully!"),
                                      ));
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MyLogin()),
                                      );
                                    },
                                    child: const Text(
                                      "LOG IN",
                                      style: TextStyle(
                                        fontFamily: "JetBrainsMono",
                                        fontSize: 14,
                                        color: Color(0xff0000EE),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Creating a column with a FloatingActionButton to go back to the previous screen
                              Column(
                                children: [
                                  FloatingActionButton.small(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Mysignup()),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.arrow_back,
                                      size: 20,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
