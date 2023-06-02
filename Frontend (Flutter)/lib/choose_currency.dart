// Importing necessary packages
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:kharcha_saathi/balance.dart';
import 'package:http/http.dart' as http;

class Mycurrency extends StatefulWidget {
  final String accessToken;
  const Mycurrency({super.key, required this.accessToken});

  @override
  State<Mycurrency> createState() => _MycurrencyState();
}

class _MycurrencyState extends State<Mycurrency> {
  _MycurrencyState() {
    _val = items[0];
  }

  final items = [
    "Nepalese Rupees",
    "Indian Rupees",
  ];
  String? _val = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Creating a scaffold with a background color and a ListView as the body
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 61, 31, 82),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Image.asset("assets/images/currency.png"),
          const SizedBox(height: 32),
          const Text(
            "Select Base Currency",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "PoppinsBold",
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 32),
          const SizedBox(
            height: 10.0,
          ),
          // Creating a DropdownButtonFormField to select a currency
          Padding(
            padding: const EdgeInsets.all(8),
            child: DropdownButtonFormField(
              value: _val,
              items: items
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _val = val as String;
                });
              },
              icon: const Icon(
                Icons.arrow_drop_down_circle,
                color: Color(0xFFA2A1B3),
              ),
              dropdownColor: const Color.fromARGB(255, 120, 61, 160),
              style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 20,
                  fontFamily: "PoopinsBold"),
              decoration: const InputDecoration(
                prefixIcon: Icon(
                  Icons.currency_bitcoin,
                  color: Color(0xFFA2A1B3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 255, 255, 255), width: 2.0),
                ),
                labelText: "Choose your default currency",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          // Displaying a Text with some instructions
          const Text(
            "The currency you use the most frequently should ideally be your base currency. Your statistics and balance will be displayed in this currency.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "PoppinsLight",
              fontSize: 14,
            ),
          ),
          const SizedBox(
            height: 102,
          ),
          // Creating a TextButton to confirm the currency selection
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
              // Sending a PATCH request to update the user's default currency
              http.Response response = await http.patch(
                  Uri.parse(
                      "https://kharchasathi-backend.onrender.com/users/currency"),
                  headers: {"Authorization": "Bearer ${widget.accessToken}"},
                  body: json.encode({"initialCurrency": _val}));

              var jsonResponse = json.decode(response.body);
              if (response.statusCode == 200) {
                // Displaying a SnackBar with a success message and navigating to the MyBalance screen
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(jsonResponse["message"]),
                ));
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => MyBalance(
                            accessToken: widget.accessToken,
                          )),
                );
              } else {
                // Displaying a SnackBar with an error message
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
