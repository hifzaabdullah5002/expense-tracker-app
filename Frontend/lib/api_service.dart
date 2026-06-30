import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Configured to point directly to your laptop over local Wi-Fi via Kestrel
  static const String baseUrl = "http://192.168.0.113:5125";
  // =====================================================
  // 1. REGISTER USER
  // =====================================================
  Future<Map<String, dynamic>> registerUser(
      String username,
      String email,
      String password,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/UserLogin/CreateUser"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          "success": true,
          "message": "Account created successfully!"
        };
      } else {
        return {
          "success": false,
          "message": response.body.isNotEmpty
              ? response.body
              : "Failed with status: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Server Connection Error: $e"
      };
    }
  }

  // =====================================================
  // 2. LOGIN USER
  // =====================================================
  Future<Map<String, dynamic>> loginUser(
      String email,
      String password,
      ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/UserLogin/Login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['status'] == true) {
          final userData = body['data']['data'];
          final prefs = await SharedPreferences.getInstance();

          await prefs.setInt('userId', userData['id']);
          await prefs.setString('username', userData['username']);
          await prefs.setString('email', userData['email']);

          return {
            "success": true,
            "data": userData,
          };
        } else {
          return {
            "success": false,
            "message": body['message'] ?? "Login failed.",
          };
        }
      } else {
        return {
          "success": false,
          "message": response.body.isNotEmpty ? response.body : "Login failed.",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Server connection failed: $e",
      };
    }
  }
  // =====================================================
  // 3. FETCH USER TRANSACTIONS
  // =====================================================
  Future<List<dynamic>> fetchTransactions(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/Expense/user/$userId"),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e) {
      throw Exception('Server error: $e');
    }
  }

  // =====================================================
  // 4. ADD EXPENSE
  // =====================================================
  Future<bool> addExpenseToApi({
    required double amount,
    required String description,
    required String date,
    required int categoryId,
    required int userId,
    required String transactionType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/Expense"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "amount": amount,
          "description": description,
          "date": date.toString(),
          "categoryId": categoryId,
          "userId": userId,
          "transactionType": transactionType,
        }),
      ).timeout(const Duration(seconds: 12));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error logging expense: $e");
      return false;
    }
  }

  // =====================================================
  // 5. FETCH DASHBOARD SUMMARY
  // =====================================================
  Future<Map<String, dynamic>> fetchDashboardSummary(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/Expense/dashboard/$userId"),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load dashboard data');
      }
    } catch (e) {
      print("Error fetching dashboard summary: $e");
      return {
        "totalIncome": 0.0,
        "totalExpense": 0.0,
        "netBalance": 0.0,
      };
    }
  }
  // =====================================================
  // 6. FETCH BUDGET SUMMARY
  // =====================================================
  Future<Map<String, dynamic>> fetchBudgetSummary(
      int userId,
      int month,
      int year,
      ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/Budget/summary/$userId?month=$month&year=$year"),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load budget summary');
      }
    } catch (e) {
      print("Error fetching budget summary: $e");
      return {
        "totalBudget": 0.0,
        "totalSpent": 0.0,
        "remaining": 0.0,
      };
    }
  }

  // =====================================================
  // 7. FETCH BUDGETS
  // =====================================================
  Future<List<dynamic>> fetchBudgets(
      int userId,
      int month,
      int year,
      ) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/Budget/user/$userId?month=$month&year=$year"),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching budgets: $e");
      return [];
    }
  }

  // =====================================================
  // 8. ADD BUDGET
  // =====================================================
  Future<bool> addBudget({
    required int userId,
    required int categoryId,
    required double budgetAmount,
    required int month,
    required int year,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/Budget"),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "userId": userId,
          "categoryId": categoryId,
          "budgetAmount": budgetAmount,
          "month": month,
          "year": year,
        }),
      ).timeout(const Duration(seconds: 12));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error adding budget: $e");
      return false;
    }
  }

  // =====================================================
  // 9. FETCH ALL CATEGORIES
  // =====================================================
  Future<List<dynamic>> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/api/Category"),
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
  // =====================================================
  // 10. DELETE EXPENSE
  // =====================================================
  Future<bool> deleteExpense(int expenseId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/api/Expense/$expenseId"),
      ).timeout(const Duration(seconds: 12));

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error deleting expense: $e");
      return false;
    }
  }

}
