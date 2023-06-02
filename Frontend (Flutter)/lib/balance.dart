// Importing required packages and files
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kharcha_saathi/dashboard.dart';

// Defining a MyBalance StatefulWidget which takes in an accessToken parameter
class MyBalance extends StatefulWidget {
  final String accessToken;
  const MyBalance({super.key, required this.accessToken});

  @override
  State<MyBalance> createState() => _MyBalanceState();
}

class _MyBalanceState extends State<MyBalance> {
  // Creating a TextEditingController to control the balance input TextField
  final TextEditingController balanceController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 31, 82),
      // Displaying a CircularProgressIndicator if isLoading is true, else displaying a ListView with balance input fields
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                const SizedBox(height: 32),
                Image.asset("assets/images/balance.png"),
                const SizedBox(height: 32),
                const Text(
                  "Set Your Cash Balance",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PoppinsBold",
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 32),
                // Creating a TextField to input the initial balance
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: balanceController,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255),
                              width: 2.0),
                        ),
                        labelText: "Initial Balance",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: 'Enter your balance',
                        hintStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  "How much cash do you have in your physical wallet?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "PoppinsLight",
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 85,
                ),
                // Creating a TextButton to confirm the balance input
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(1)),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    minimumSize: const Size.fromHeight(80),
                  ),
                  child: const Text(
                    "CONFIRM",
                    style: TextStyle(
                        fontSize: 24,
                        fontFamily: "PoppinsBold",
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    int? amount = int.tryParse(balanceController.text);
                    if (amount == null) {
                      // Displaying a SnackBar with an error message if an invalid balance value is entered
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Invalid balance value."),
                      ));
                      setState(() {
                        isLoading = false;
                      });
                      return;
                    }
                    // Creating an http PATCH request to update the user's income with the entered amount
                    http.Response response = await http.patch(
                        Uri.parse(
                            "https://kharchasathi-backend.onrender.com/users/income"),
                        headers: {
                          "Authorization": "Bearer ${widget.accessToken}"
                        },
                        body: json.encode({
                          "amount": amount,
                        }));

                    var jsonResponse = json.decode(response.body);
                    // Displaying a SnackBar with a success message and navigating to the MyDashboard screen
                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(jsonResponse["message"]),
                      ));
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) =>
                                MyDashboard(accessToken: widget.accessToken)),
                      );
                    } else {
                      // Setting isLoading to false and displaying a SnackBar with an error message
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(jsonResponse["error"]),
                      ));
                    }
                  },
                )
              ],
            ),
    );
  }
}
