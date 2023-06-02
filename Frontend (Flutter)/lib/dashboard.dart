// Importing necessary packages
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kharcha_saathi/expense.dart';
import 'package:kharcha_saathi/income.dart';
import 'package:kharcha_saathi/login.dart';
import 'package:kharcha_saathi/records.dart';
import 'package:kharcha_saathi/settings.dart';
import 'package:fl_chart/fl_chart.dart';

class MyDashboard extends StatefulWidget {
  final String accessToken;
  const MyDashboard({super.key, required this.accessToken});

  @override
  State<MyDashboard> createState() => _MyDashboardState();
}

// Create an enum to represent the menu items in the dashboard.
enum MenuItem { records, settings, budget, goals }

// Create a State for the dashboard.
class _MyDashboardState extends State<MyDashboard> {
  // Create a list of colors for the background gradient.
  final List<Color> _colorList = [const Color(0xff396A19), const Color(0xffC64040)];
  // Declare a Future object for getting the total expenses and income.
  late Future<List<int>> totalFuture;
  var box = Hive.box('userData');
  // Declare variables to store the total expenses and income.
  int expense = 0;
  int income = 0;
  bool isLoading = false;
  // Declare a variable to store the user's balance from the server.
  int jsonBalance = 0;
  // Declare a variable to store the total expenses and income from the server.
  var jsonTotal;
  // Declare a boolean to keep track of loading state for the container.
  bool isContainerLoading = false;

  // Function to get the user's balance from the server.
  void getBalance() async {
    setState(() {
      isLoading = true;
    });

    Dio dio = Dio();

    dio.options.headers = {
      'Authorization':
          'Bearer ${widget.accessToken}', // Set the authorization header with the user's access token.
    };

    try {
      Response response = await dio
          .get('https://kharchasathi-backend.onrender.com/users/balance');
      if (response.statusCode == 200) {
        setState(() {
          int balance = response.data["balance"] as int;
          jsonBalance = balance; // Set the balance from the response data.
          isLoading = false; // Set isLoading back to false
        });
      } else {
        isLoading = false;
        // Show an error message if the response status code is not 200.
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      isLoading = false;
      // Show an error message if an exception occurs.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  Future<List<int>> getTotal() async {
    setState(() {
      isContainerLoading = true;
    });

    Dio dio = Dio();

    dio.options.headers = {
      'Authorization':
          'Bearer ${widget.accessToken}', // Set the authorization header with the user's access token.
    };

    try {
      Response response = await dio
          .get('https://kharchasathi-backend.onrender.com/users/Total');
      setState(() {
        isContainerLoading = false; // Set isContainerLoading back to false.
      });

      if (response.statusCode == 200) {
        setState(() {
          expense = int.parse(response.data["expense"].toString());
          income = int.parse(response.data["income"].toString());
        });

        return [expense, income]; // Return the expenses and income as a list.
      } else {
        print(response.statusCode);

        return [0, 0]; // return 0 for both expense and income on error
      }
    } catch (e) {
      print(e);

      return [0, 0]; // return 0 for both expense and income on exception
    }
  }

  @override
  // Initialize the state of the widget.
  void initState() {
    getBalance();
    box.put("accessToken", widget.accessToken);
    totalFuture = getTotal();
    super.initState();
  }

  // Widget that displays a congratulatory message and an image for a profit.
  final Widget profitContainer = Container(
    // Set the properties of the container such as width, height, and color.
    width: 500,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF3E1F52),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/+ve.png',
            width: 150,
            height: 200,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "Congratulations!",
                style: TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 22,
                    color: Color(0xFF396A19)),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "I see you buddy. Your\neffort is paying off,\nkeep it up and you’ll\nsoon reach the end goal.",
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "You’re UP",
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 20,
                        color: Color(0xFF396A19)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.thumb_up,
                    color: Color(0xFF396A19),
                    size: 25,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    ),
  );

  // Widget that displays an encouraging message and an image for a loss.
  final Widget lossContainer = Container(
    // Set the properties of the container such as width, height, and color.
    width: 500,
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFF3E1F52),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/-ve.png',
            width: 150,
            height: 200,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Text(
                "PICK IT UP!",
                style: TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 25,
                    color: Color(0xFFC64040)),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Your efforts have not\ngone unnoticed. Keep up\nthe pace because the end\ngoal is within reach.",
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15,
                    color: Color.fromARGB(255, 255, 255, 255)),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    "You’re DOWN",
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 20,
                        color: Color(0xFFC64040)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.thumb_down,
                    color: Color(0xFFC64040),
                    size: 25,
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: const Color(0xFF161341),
          title: const Text('KHARCHA SAATHI'),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              // Show confirmation dialog on logout button press
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('LOGOUT'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    // Cancel button to dismiss the dialog
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('CANCEL'),
                    ),
                    // OK button to clear the box and go to login page
                    TextButton(
                      onPressed: () {
                        box.clear();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyLogin()));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.logout),
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                // Create a popup menu with menu items
                return PopupMenu(
                  menuList: [
                    // Settings menu item with onTap event to navigate to MySettings screen
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.settings,
                        ),
                        title: const Text("Settings"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MySettings()),
                          );
                        },
                      ),
                    ),
                    // Records menu item with onTap event to navigate to MyRecords screen
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.folder_circle_fill,
                        ),
                        title: const Text("Records"),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyRecords()),
                          );
                        },
                      ),
                    ),
                    // Goals menu item with onTap event to show a snackbar indicating the feature is not yet available
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.car_detailed,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Goals",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "This feature will be available in the future build!"),
                          ));
                        },
                      ),
                    ),
                    // Budgets menu item with onTap event to show a snackbar indicating the feature is not yet available
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(
                          CupertinoIcons.money_dollar_circle_fill,
                          color: Colors.red,
                        ),
                        title: const Text(
                          "Budgets",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                                "This feature will be available in the future build!"),
                          ));
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                // Display the current date
                Text(
                  DateFormat.yMMMEd().format(DateTime.now()),
                  style: const TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 15,
                      color: Color(0xFFFB94FD)),
                ),
                const SizedBox(
                  height: 12,
                ),
                // If container is loading, display circular progress indicator, otherwise display either profit or loss container
                isContainerLoading
                    ? Container(
                        width: 500,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xFF3E1F52),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ))
                    : income >= expense
                        ? profitContainer
                        : lossContainer,
                const SizedBox(
                  height: 10,
                ),
                // Display a container for income and expense records
                Container(
                  width: 500,
                  height: 397,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF3E1F52),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      // Display a chart showing the income and expenses
                      FutureBuilder<List<int>>(
                        future: totalFuture,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return SizedBox(
                              height: 200,
                              child: PieChart(
                                PieChartData(
                                  sections: [
                                    PieChartSectionData(
                                      value: snapshot.data![0].toDouble(),
                                      color: _colorList[1],
                                      title: '',
                                      radius: 50,
                                      badgeWidget: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Expenses',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "PoppinsBold",
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '\$${snapshot.data![0]}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: "PoppinsBold",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    PieChartSectionData(
                                      value: snapshot.data![1].toDouble(),
                                      color: _colorList[0],
                                      title: '',
                                      radius: 50,
                                      badgeWidget: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Income',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: "PoppinsBold",
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            '\$${snapshot.data![1]}',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontFamily: "PoppinsBold",
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                  sectionsSpace: 0,
                                  centerSpaceRadius:
                                      50, // set to create a hole in the chart
                                  startDegreeOffset: 180,
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                ),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error: ${snapshot.error}'),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const Divider(
                        thickness: 2,
                        color: Color(0xffFB94FD),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Create a container with balance information
                      Container(
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: const Color(0xfF7e3fa7),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              // If data is being loaded, show a progress indicator, else show balance information
                              isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Text(
                                      'Rs. ${jsonBalance.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontFamily: "PoppinsBold",
                                          fontSize: 20,
                                          color: Colors.white),
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          // Create a row with buttons to add income and expense
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Create a button to add income
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 4,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to add income screen
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyIncome()),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.green,
                                    size: 50,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              // Create a button to add expense
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 4,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Navigate to add expense screen
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const Myexpense()),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.red,
                                    size: 50,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class PopupMenu extends StatelessWidget {
  final List<PopupMenuEntry> menuList;

  // Constructor with required named parameter 'menuList'
  const PopupMenu({super.key, required this.menuList});

  @override
  Widget build(BuildContext context) {
    // Returns a PopupMenuButton widget
    return PopupMenuButton(
      itemBuilder: ((context) =>
          menuList), // Sets the itemBuilder property to the provided menuList
    );
  }
}
