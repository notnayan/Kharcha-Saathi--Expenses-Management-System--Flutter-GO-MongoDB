// Importing necessary packages
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:kharcha_saathi/dashboard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Define a widget called MyIncome and make it a StatefulWidget.
class MyIncome extends StatefulWidget {
  const MyIncome({super.key});

  // Override createState() to create an instance of _MyIncomeState.
  @override
  State<MyIncome> createState() => _MyIncomeState();
}

// Define a widget called _MyIncomeState and make it a State<MyIncome>.
class _MyIncomeState extends State<MyIncome> {
  // Define noteController and incomeController as TextEditingController.
  final TextEditingController noteController = TextEditingController();
  final TextEditingController incomeController = TextEditingController();
  // Define isLoading as bool and box as a Hive box.
  bool isLoading = false;
  var box = Hive.box('userData');
  // Dispose of all controllers.
  @override
  void dispose() {
    noteController.dispose();
    incomeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get accessToken from Hive box.
    String accessToken = box.get("accessToken");
    // Create a scaffold with backgroundColor, appBar, and body widgets.
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 31, 82),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161341),
        leading: BackButton(
            onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MyDashboard(
                            accessToken: accessToken,
                          )),
                )),
        title: const Text('My Income'),
      ),
      // If isLoading is true, show a centered CircularProgressIndicator widget.
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          // Otherwise, show a Column widget with various child widgets.
          : Column(
              children: [
                // Add Padding widget with EdgeInsets to create some space.
                const Padding(padding: EdgeInsets.fromLTRB(1000, 15, 0, 0)),
                // Show today's date using DateFormat and TextStyle.
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
                // Display a header asking for the income.
                const Text(
                  "What's the income?",
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 32,
                      color: Color.fromARGB(255, 255, 255, 255)),
                  textAlign: TextAlign.center,
                ),
                // Create a SingleChildScrollView widget to allow for scrolling
                // within the Column widget.
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // Add a TextField widget for the income note description
                      Padding(
                        padding: const EdgeInsets.all(15),
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
                      Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.001,
                            right: 35,
                            left: 35),
                        child: TextField(
                          controller: incomeController,
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
                              labelText: "INCOME",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              hintText: 'Enter your income',
                              hintStyle: TextStyle(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      // Add an ElevatedButton widget for entering the income.
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            // Try parsing the income amount as an int.
                            int? amount = int.tryParse(incomeController.text);
                            // If the amount is null, show a SnackBar and set isLoading to false.
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
                            // Send a PATCH request to the API with the income note description and amount.
                            http.Response response = await http.patch(
                                Uri.parse(
                                    "https://kharchasathi-backend.onrender.com/users/income"),
                                headers: {
                                  "Authorization": 'Bearer $accessToken'
                                },
                                body: json.encode({
                                  "description": noteController.text,
                                  "amount": amount,
                                }));

                            var jsonResponse = json.decode(response.body);
                            // If the response status code is 200, show a SnackBar with the message and navigate to MyDashboard.
                            if (response.statusCode == 200) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(jsonResponse["message"]),
                              ));
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => MyDashboard(
                                          accessToken: accessToken,
                                        )),
                              );
                            }
                            // Otherwise, show a SnackBar with the error message and set isLoading to false.
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
                ),
              ],
            ),
    );
  }
}
