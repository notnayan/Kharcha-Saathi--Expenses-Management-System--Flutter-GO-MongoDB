// Import necessary packages.
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kharcha_saathi/dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Create a StatefulWidget for Myexpense.
class Myexpense extends StatefulWidget {
  const Myexpense({super.key});

  @override
  State<Myexpense> createState() => _MyexpenseState();
}

// Create the state for Myexpense.
class _MyexpenseState extends State<Myexpense> {
  // Create controllers for note and expense text fields.
  final TextEditingController noteController = TextEditingController();
  final TextEditingController expenseController = TextEditingController();
  // Get the user data box from Hive.
  var box = Hive.box('userData');
  // Create a isLoading boolean to track whether the data is loading or not.
  bool isLoading = false;

  @override
  void dispose() {
    noteController.dispose();
    expenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the access token from the user data box.
    String accessToken = box.get("accessToken");
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 31, 82),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161341),
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          MyDashboard(accessToken: accessToken)),
                )),
        title: const Text('My Expense'),
      ),
      // If data is loading, show a CircularProgressIndicator, otherwise, show the expense input form.
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(1000, 15, 0, 0)),
                Text(
                  DateFormat.yMMMEd().format(DateTime.now()),
                  style: const TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 15,
                      color: Color(0xFFFB94FD)),
                ),
                const SizedBox(
                  height: 32,
                ),
                const Text(
                  "What's the expense?",
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 32,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  textAlign: TextAlign.center,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      // Create a text input field for the expense note.
                      child: TextField(
                        controller: noteController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(color: Colors.white),
                          icon: Icon(
                            Icons.note_alt_outlined,
                            color: Color(0xFF9F72FF),
                          ), //icon at head of input
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    // Create a SingleChildScrollView to ensure the text input field is scrollable.
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.001,
                            right: 35,
                            left: 35),
                        // Create a text input field for the expense amount.
                        child: TextField(
                          controller: expenseController,
                          // Create input decoration for the text input field.
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
                              labelText: "EXPENSE",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'Enter your expense',
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    // Create an ElevatedButton for submitting the expense.
                    ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });

                          // Parse the expense amount from the text input field.
                          int? amount = int.tryParse(expenseController.text);
                          if (amount == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Invalid balance value."),
                            ));
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }
                          // Send a PATCH request to the backend API to add the expense.
                          http.Response response = await http.patch(
                              Uri.parse(
                                  "https://kharchasathi-backend.onrender.com/users/expense"),
                              headers: {"Authorization": "Bearer $accessToken"},
                              body: json.encode({
                                "description": noteController.text,
                                "amount": amount,
                              }));

                          var jsonResponse = json.decode(response.body);
                          if (response.statusCode == 200) {
                            // Show a success message and navigate back to the dashboard.
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(jsonResponse["message"]),
                            ));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MyDashboard(accessToken: accessToken)),
                            );
                          } else {
                            // Show an error message if the request fails.
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(jsonResponse["error"]),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            fixedSize: const Size(150, 60)),
                        child: const Text(
                          "ENTER",
                          style: TextStyle(
                              fontFamily: "PoppinsBold",
                              color: Colors.white,
                              fontSize: 24),
                        ))
                  ],
                ),
              ],
            ),
    );
  }
}
