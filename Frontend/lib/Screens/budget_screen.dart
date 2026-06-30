import 'package:flutter/material.dart';
import 'package:hifza_expense_tracker/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimpleBudgetScreen extends StatefulWidget {
  const SimpleBudgetScreen({super.key});

  @override
  State<SimpleBudgetScreen> createState() => _SimpleBudgetScreenState();
}
class _SimpleBudgetScreenState extends State<SimpleBudgetScreen> {
  double totalBudget = 0.0;
  double totalSpent = 0.0;
  double remaining = 0.0;
  List<dynamic> budgetCategories = [];
  Map<int, String> categoryMap = {};
  bool isLoading = true;

  final List<String> fixedCategories = ['food', 'Transfer', 'Transportation', 'Education'];

  final int currentMonth = DateTime.now().month;
  final int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchApiBudgetData();
  }

  Future<void> _fetchApiBudgetData() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      int userId = prefs.getInt('userId') ?? 1;

      // 1. Fetch live categories mapped with SQL
      final categoriesList = await ApiService().fetchCategories();
      categoryMap.clear();
      if (categoriesList != null) {
        for (var cat in categoriesList) {
          if (cat != null && cat['id'] != null && cat['name'] != null) {
            categoryMap[cat['id'] as int] = cat['name'].toString();
          }
        }
      }

      // 2. Load fresh summary records directly from server databases
      final summary = await ApiService().fetchBudgetSummary(userId, currentMonth, currentYear);

      // 3. Load structured relational budget mapping logs from backend APIs
      final budgetsList = await ApiService().fetchBudgets(userId, currentMonth, currentYear);

      if (!mounted) return;
      setState(() {
        if (summary != null) {
          totalBudget = double.tryParse(summary['totalBudget'].toString()) ?? 0.0;
          totalSpent = double.tryParse(summary['totalSpent'].toString()) ?? 0.0;
          remaining = double.tryParse(summary['remaining'].toString()) ?? 0.0;
        }
        budgetCategories = budgetsList ?? [];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database Sync Status: $e')),
      );
    }
  }
  void _showEditBudgetDialog() {
    final TextEditingController amountController = TextEditingController();
    String? selectedCatName;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Set Category Budget'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: selectedCatName,
                    hint: const Text("Select Category"),
                    isExpanded: true,
                    items: fixedCategories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setDialogState(() { selectedCatName = val; });
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Enter budget amount',
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xff368983))),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xff368983)),
                  onPressed: () async {
                    double? newAmount = double.tryParse(amountController.text);
                    if (newAmount != null && newAmount > 0 && selectedCatName != null) {
                      Navigator.pop(context);
                      setState(() => isLoading = true);

                      // Selected Name se uski asli SQL Database ID find karne ka loop
                      int targetCategoryId = 1;
                      categoryMap.forEach((id, name) {
                        if (name.toLowerCase() == selectedCatName!.toLowerCase()) {
                          targetCategoryId = id;
                        }
                      });

                      final prefs = await SharedPreferences.getInstance();
                      int userId = prefs.getInt('userId') ?? 1;

                      bool success = await ApiService().addBudget(
                        userId: userId,
                        categoryId: targetCategoryId,
                        budgetAmount: newAmount,
                        month: currentMonth,
                        year: currentYear,
                      );

                      if (success) {
                        _fetchApiBudgetData();
                      } else {
                        if (!mounted) return;
                        setState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to update budget on Server')),
                        );
                      }
                    }
                  },
                  child: const Text('Update', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    double totalProgress = totalBudget > 0 ? (totalSpent / totalBudget) : 0.0;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Budget Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xff368983),
        centerTitle: true,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xff368983)))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // <-- Colons ':' add kar k error fix kar diya h
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff368983),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Monthly Budget', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      IconButton(
                        onPressed: _showEditBudgetDialog,
                        icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  Text('Rs. ${totalBudget.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Spent So Far', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('Rs. ${totalSpent.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Remaining', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          Text('Rs. ${remaining.toStringAsFixed(0)}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: totalProgress > 1.0 ? 1.0 : totalProgress,
                      backgroundColor: Colors.white24,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('Category Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 15),
            Expanded(
              child: budgetCategories.isEmpty
                  ? const Center(child: Text('No category budget logs found.', style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                itemCount: budgetCategories.length,
                itemBuilder: (context, index) {
                  var item = budgetCategories[index];
                  if (item == null) return Container();
                  double amount = double.tryParse(item['budgetAmount'].toString()) ?? 0.0;
                  int catId = item['categoryId'] ?? 0;
                  String catName = categoryMap[catId] ?? 'Category $catId';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(catName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        Text('Rs. ${amount.toStringAsFixed(0)}', style: const TextStyle(fontSize: 16, color: Color(0xff368983), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
