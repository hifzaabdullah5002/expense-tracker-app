import 'package:flutter/material.dart';
import 'package:hifza_expense_tracker/Screens/add.dart';
import 'package:hifza_expense_tracker/Screens/home.dart';
import 'package:hifza_expense_tracker/Screens/statistics.dart';
import 'package:hifza_expense_tracker/Screens/budget_screen.dart'; // Budget file connection
import 'package:hifza_expense_tracker/Screens/profile.dart';       // Profile file connection

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}
class _BottomState extends State<Bottom> {
  int index_color = 0;

  // Screens ki list ko sahi class name (SimpleBudgetScreen) k sath initialize kiya h
  late final List<Widget> Screen;

  @override
  void initState() {
    super.initState();
    Screen = [
      const Home(),
      const Statistics(),
      const SimpleBudgetScreen(), // Sahi class name call kiya jo humne banayi thi
      const ProfileScreen(),
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Add_Screen()));
        },
        backgroundColor: const Color(0xff368983),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              const SizedBox(width: 20), // Center button k space ko exact fit kiya h
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color: index_color == 2 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 3 ? const Color(0xff368983) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
