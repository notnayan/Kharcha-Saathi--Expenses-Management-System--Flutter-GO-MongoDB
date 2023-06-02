// Import necessary packages.
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;

class MyRecords extends StatefulWidget {
  const MyRecords({super.key});

  @override
  State<MyRecords> createState() => _MyRecordsState();
}

class _MyRecordsState extends State<MyRecords> {
  // Initialize Hive box and variables
  var box = Hive.box('userData');
  var jsonList;
  int jsonBalance = 0;
  bool _showAllTransactions = true;
  bool _showLastWeekTransactions = false;
  bool _showLastMonthTransactions = false;
  int itemCount = 0;
  bool isLoading = false;

  // Get user balance from API
  void getBalance() async {
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();

    dio.options.headers = {
      'Authorization': 'Bearer ${box.get("accessToken")}',
    };

    try {
      Response response = await dio
          .get('https://kharchasathi-backend.onrender.com/users/balance');
      if (response.statusCode == 200) {
        setState(() {
          int balance = response.data["balance"] as int;
          jsonBalance = balance;
          isLoading = false; // set isLoading back to false
        });
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  // Get transactions from API
  void getTransaction() async {
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();

    dio.options.headers = {
      'Authorization': 'Bearer ${box.get("accessToken")}',
    };

    try {
      Response response = await dio
          .get('https://kharchasathi-backend.onrender.com/transaction');
      if (response.statusCode == 200) {
        setState(() {
          jsonList = response.data["transactions"] as List;
          isLoading = false;
        });
      } else {
        isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  void initState() {
    getBalance();
    getTransaction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Determine the number of transactions to display based on filters
    if (_showLastWeekTransactions) {
      // Filter transactions for the last 7 days
      DateTime now = DateTime.now();
      DateTime lastWeek = now.subtract(const Duration(days: 7));
      itemCount = jsonList
          .where((transaction) =>
              DateTime.parse(transaction['date']).isAfter(lastWeek))
          .length;
    } else if (_showLastMonthTransactions) {
      // Filter transactions for the last month
      DateTime now = DateTime.now();
      DateTime lastMonth = DateTime(now.year, now.month - 1, now.day);
      itemCount = jsonList
          .where((transaction) =>
              DateTime.parse(transaction['date']).isAfter(lastMonth))
          .length;
    } else {
      itemCount = jsonList?.length ?? 0;
    }

    return Scaffold(
      // Set the background color to black
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Set the app bar background color to a dark blue
        backgroundColor: const Color(0xFF161341),
        title: const Text('Records'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              // Show today's date in a specific format
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: const TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 15,
                  color: Color(0xFFFB94FD),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 75,
                width: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color(0xfF7e3fa7),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Show a money icon
                          const Icon(
                            FontAwesomeIcons.moneyCheckDollar,
                            color: Colors.white,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const Column(
                            children: [
                              // Show "NPR" and "Balance" text
                              Text(
                                "NPR",
                                style: TextStyle(
                                    fontFamily: "PoppinsBold",
                                    fontSize: 20,
                                    color: Colors.white),
                              ),
                              Text(
                                "Balance",
                                style: TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 15,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(
                                width: 8,
                              ),
                              isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(
                                      // Show the current balance
                                      'Rs. ${jsonBalance.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontFamily: "PoppinsBold",
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                              const SizedBox(
                                width: 25,
                              ),
                              InkWell(
                                onTap: () {
                                  // Show a dialog to download records
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Download Records'),
                                      content: const Text(
                                          'Are you sure you want to download the records?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, false),
                                          child: const Text('CANCEL'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context, true);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "Records have been downloaded successfully!"),
                                              ),
                                            );
                                            await generatePDFReport(jsonList,
                                                '/storage/emulated/0/Download/expenses.pdf');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ).then((value) {
                                    if (value == true) {}
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    FontAwesomeIcons.download,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // Create three buttons to filter the records
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAllTransactions = true;
                        _showLastWeekTransactions = false;
                        _showLastMonthTransactions = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showAllTransactions
                          ? const Color(0xFFFB94FD)
                          : Colors.white,
                    ),
                    child: const Text(
                      'All',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAllTransactions = false;
                        _showLastWeekTransactions = true;
                        _showLastMonthTransactions = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showLastWeekTransactions
                          ? const Color(0xFFFB94FD)
                          : Colors.white,
                    ),
                    child: const Text(
                      'Last 7 Days',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showAllTransactions = false;
                        _showLastWeekTransactions = false;
                        _showLastMonthTransactions = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showLastMonthTransactions
                          ? const Color(0xFFFB94FD)
                          : Colors.white,
                    ),
                    child: const Text(
                      'Last Month',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // If isLoading is true, shows a Center widget containing a CircularProgressIndicator.
              // If isLoading is false, shows an Expanded widget containing a ListView.builder.
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (BuildContext context, int index) {
                          bool isExpense = jsonList[index]["type"] == "expense";
                          Color color = isExpense ? Colors.red : Colors.green;
                          return Column(
                            children: [
                              ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            DateFormat('E, MMM d, yyyy').format(
                                              DateTime.parse(
                                                  jsonList[index]["date"]),
                                            ),
                                            style: const TextStyle(
                                              fontFamily: "PoppinsBold",
                                              fontSize: 18,
                                              color: Color(0xffFB94FD),
                                            ),
                                          ),
                                          Text(
                                            jsonList[index]["type"] ?? "",
                                            style: TextStyle(
                                              fontFamily: "PoppinsBold",
                                              fontSize: 18,
                                              color: color,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.note_alt_outlined,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                jsonList[index]
                                                        ["description"] ??
                                                    "",
                                                style: const TextStyle(
                                                  fontFamily: "PoppinsMedium",
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isExpense
                                              ? Icons.arrow_downward
                                              : Icons.arrow_upward,
                                          color: isExpense
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          "NPR ${jsonList[index]["amount"] ?? "0.00"}",
                                          style: TextStyle(
                                            fontFamily: "PoppinsBold",
                                            fontSize: 18,
                                            color: isExpense
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                thickness: 2,
                                color: Color(0xffFB94FD),
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> generatePDFReport(List<dynamic> jsonList, String filePath) async {
  // Creates a new Document object from the pdf library.
  final pdf = pw.Document();
  // Adds a new page to the document using a MultiPage widget from the pdf library.
  pdf.addPage(pw.MultiPage(
      build: (pw.Context context) => <pw.Widget>[
            // Adds a header to the page.
            pw.Header(level: 0, child: pw.Text('Expense Report')),
            // Adds a table to the page using the data from jsonList.
            pw.Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Date', 'Type', 'Description', 'Amount'],
              ...jsonList.map((record) {
                return <String>[
                  record['date'],
                  record['type'],
                  record['description'],
                  record['amount'].toString(),
                ];
              })
            ]),
          ]));
  // Creates a new File object using the provided filePath.
  final file = File(filePath);
  // Saves the pdf document as bytes to the file.
  await file.writeAsBytes(await pdf.save());
  // Saves the pdf document.
  pdf.save().then((value) {});
}
