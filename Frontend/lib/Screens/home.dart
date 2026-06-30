import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Sessions track management
import 'package:hifza_expense_tracker/api_service.dart'; // Production endpoint link connectivity

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentUserId = 1;
  String currentUserName = "User";

  final List<String> day = [
    'Monday', "Tuesday", "Wednesday", "Thursday", 'friday', 'saturday', 'sunday'
  ];

  @override
  void initState() {
    super.initState();
    _loadLoggedInUser(); // App execution logs reader startup setup pipeline
  }

  Future<void> _loadLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getInt('userId') ?? 1;
      currentUserName = prefs.getString('username') ?? "Guest User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        // FIXED FLOW: Hive dependency ko complete bypass karke poori transaction array direct server linked dynamic check par laga di hai
        child: FutureBuilder<List<dynamic>>(
          future: ApiService().fetchTransactions(currentUserId),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xff368983)),
              );
            }

            List<dynamic> transactionsList = snapshot.data ?? [];

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: SizedBox(height: 340, child: _head()),
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transactions History',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19, color: Colors.black),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final currentTransaction = transactionsList[index];
                      return getList(currentTransaction, index);
                    },
                    childCount: transactionsList.length,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
  // =======================================================================
  // REAL-TIME SYNCED DISMISSIBLE WRAPPER WITH IMMEDIATE SNAPSHOT RELOADS
  // =======================================================================
  Widget getList(dynamic transaction, int index) {
    final int sqlRecordId = transaction['id'] ?? 0;

    return Dismissible(
      key: Key(sqlRecordId.toString()), // Boundaries tracking using primary network tags
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        try {
          // 1. Database server link ko genuine primary dynamic link call pass ki hai
          bool success = await ApiService().deleteExpense(sqlRecordId);

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cleared completely from SQL Database server registries!')),
            );
          }

          // 2. State dynamic lifecycle rebuild: Server se data clear hote hi layout refresh trigger ho jaye ga
          setState(() {});
        } catch (e) {
          print("Live network pipeline execution fail trace logs: $e");
        }
      },
      child: get(transaction),
    );
  }
  // =======================================================================
  // FIELD MAPPER INJECTOR METHOD CONVERTING REST ARRAYS DIRECT INTO LAYOUTS
  // =======================================================================
  ListTile get(dynamic transaction) {
    String categoryName = transaction['description'] ?? 'food';
    String txType = transaction['transactionType'] ?? 'Expand';
    String displayAmount = transaction['amount']?.toString() ?? '0';
    String rawDate = transaction['date'] ?? '';

    String cleanDate = rawDate.length > 10 ? rawDate.substring(0, 10) : rawDate;

    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          ['food', 'Transfer', 'Transportation', 'Education'].contains(categoryName)
              ? 'images/$categoryName.png'
              : 'images/food.png',
          height: 40,
        ),
      ),
      title: Text(
        categoryName,
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black),
      ),
      subtitle: Text(
        cleanDate,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
      ),
      trailing: Text(
        "Rs. $displayAmount",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 19,
          color: txType == 'Income' ? Colors.green : Colors.red,
        ),
      ),
    );
  }
  // =======================================================================
  // LIVE COMPUTING HEADER DASHBOARD PIPELINE WITH SYSTEM HOUR GREETINGS
  // =======================================================================
  Widget _head() {
    int currentHour = DateTime.now().hour;
    String greetingMessage = "Hello";

    if (currentHour >= 4 && currentHour < 12) {
      greetingMessage = "Good morning";
    } else if (currentHour >= 12 && currentHour < 16) {
      greetingMessage = "Good afternoon";
    } else if (currentHour >= 16 && currentHour < 22) {
      greetingMessage = "Good evening";
    } else {
      greetingMessage = "Good night";
    }

    return FutureBuilder<Map<String, dynamic>>(
        future: ApiService().fetchDashboardSummary(currentUserId), // Live calculations query routes endpoint
        builder: (context, snapshot) {
          double netBalance = 0.0;
          double totalIncome = 0.0;
          double totalExpense = 0.0;

          if (snapshot.hasData && snapshot.data != null) {
            netBalance = (snapshot.data!['netBalance'] ?? 0.0).toDouble();
            totalIncome = (snapshot.data!['totalIncome'] ?? 0.0).toDouble();

            // FIXED CALCULATION LOGIC: Dynamic server math calculation sign parameters correction
            double serverExpense = (snapshot.data!['totalExpense'] ?? 0.0).toDouble();
            totalExpense = serverExpense.abs(); // Expense absolute algorithm tracking lock
          }

          return Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 240,
                    decoration: const BoxDecoration(
                      color: Color(0xff368983),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 35,
                          left: 320,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Container(
                              height: 40,
                              width: 40,
                              color: const Color.fromRGBO(250, 250, 250, 0.1),
                              child: const Icon(Icons.notification_add_outlined, size: 30, color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 35, left: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(greetingMessage, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Color.fromARGB(255, 224, 223, 223))),
                              Text(currentUserName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 140,
                left: 20,
                right: 20,
                child: Container(
                  height: 170,
                  decoration: BoxDecoration(
                    boxShadow: [const BoxShadow(color: Color.fromRGBO(47, 125, 121, 0.3), offset: Offset(0, 6), blurRadius: 12, spreadRadius: 6)],
                    color: const Color.fromARGB(255, 47, 125, 121),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Balance', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white)),
                            Icon(Icons.more_horiz, color: Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Row(
                          children: [
                            Text(
                              'Rs. ${netBalance.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(radius: 13, backgroundColor: Color.fromARGB(255, 85, 145, 141), child: Icon(Icons.arrow_downward, color: Colors.white, size: 16)),
                                const SizedBox(width: 7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Income', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromARGB(255, 216, 214, 214))),
                                    Text('Rs. ${totalIncome.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const CircleAvatar(radius: 13, backgroundColor: Color.fromARGB(255, 85, 145, 141), child: Icon(Icons.arrow_upward, color: Colors.white, size: 16)),
                                const SizedBox(width: 7),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Expenses', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Color.fromARGB(255, 216, 214, 214))),
                                    Text('Rs. ${totalExpense.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        });
  }
}
