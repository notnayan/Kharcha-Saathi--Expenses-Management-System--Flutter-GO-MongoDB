// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:kharcha_saathi/choose_currency.dart';
import 'package:kharcha_saathi/dashboard.dart';
import 'package:kharcha_saathi/signup.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// This is a stateful widget that represents the Login screen.
class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

// This is the state of the MyLogin widget
class _MyLoginState extends State<MyLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  bool isLoading = false;
  bool _isObscure = true;
  var box = Hive.box('userData');

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Set the background image of the container
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login.png"), fit: BoxFit.fill)),
      child: Scaffold(
        // Make the scaffold's background transparent
        backgroundColor: Colors.transparent,
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    // Add the welcome text and continue message
                    Container(
                      padding: const EdgeInsets.only(left: 51, top: 425),
                      child: const Column(
                        children: [
                          Text(
                            "Welcome Back Buddy",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontFamily: "JetBrainsMono"),
                          ),
                          Text(
                            "Let’s continue from where we left off",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontFamily: "JetBrainsMonoLight"),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      // Set the top padding to match device height
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.65,
                          right: 35,
                          left: 35),
                      child: Column(
                        children: [
                          // Add the email text field
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              RegExp emailReg = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
                              if (!emailReg.hasMatch(value.toString())) {
                                return "Invalid Email";
                              }
                              return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Email",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          // Add the password text field
                          TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              RegExp passReg = RegExp(
                                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                              if (!passReg.hasMatch(value.toString())) {
                                return "Invalid Password";
                              }
                              return null;
                            },
                            controller: passwordController,
                            obscureText: _isObscure,
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
                                  color: Colors.black,
                                ),
                              ),
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              hintText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),

                          const SizedBox(
                            height: 16,
                          ),
                          Column(
                            children: [
                              // Add the Login button
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  http.Response response = await http.post(
                                      Uri.parse(
                                          "https://kharchasathi-backend.onrender.com/users/login"),
                                      body: json.encode({
                                        "email": emailController.text,
                                        "password": passwordController.text
                                      }));

                                  var jsonResponse = json.decode(response.body);
                                  if (response.statusCode == 200) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(jsonResponse["message"]),
                                    ));
                                    if (jsonResponse["initialCurrency"] == "" &&
                                        jsonResponse["balance"] == 0) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => Mycurrency(
                                                accessToken: jsonResponse[
                                                    "accessToken"])),
                                      );
                                    } else {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => MyDashboard(
                                                  accessToken: jsonResponse[
                                                      "accessToken"],
                                                )),
                                      );
                                    }
                                  } else {
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
                                  backgroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                      fontFamily: "JetBrainsMono",
                                      fontSize: 12),
                                ),
                                child: const Text("LOG IN"),
                              ),
                              // Add the Sign up text and button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don’t have an account?",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: "JetBrainsMono"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Mysignup()),
                                        );
                                      },
                                      child: const Text("SIGN UP",
                                          style: TextStyle(
                                              fontFamily: "JetBrainsMono",
                                              fontSize: 14,
                                              color: Color(0xff0000EE))))
                                ],
                              )
                            ],
                          )
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
