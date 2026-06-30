import 'package:flutter/material.dart';
import 'package:hifza_expense_tracker/api_service.dart';
import 'package:hifza_expense_tracker/widgets/bottomnavigationbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Input fields controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isLoginForm = true; // Mode tracker: true = Log In, false = Sign Up

  void _showActionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xff368983))),
          ),
        ],
      ),
    );
  }

  // Combined logic engine for both Login and Signup actions
  void _handleSubmitAction() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String username = _usernameController.text.trim();

    // Validations based on active mode
    if (email.isEmpty || password.isEmpty || (!_isLoginForm && username.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all validation fields.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (_isLoginForm) {
      // 1. EXECUTE LOG IN ACTION THROUGH REVERSE USB TUNNEL
      final result = await ApiService().loginUser(email, password);
      setState(() { _isLoading = false; });

      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Bottom()),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Authentication failed.')),
        );
      }
    } else {
      // 2. EXECUTE SIGN UP ACTION THROUGH REVERSE USB TUNNEL
      final result = await ApiService().registerUser(username, email, password);
      setState(() { _isLoading = false; });

      if (result['success'] == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created Successfully! Please Log in now.')),
        );
        setState(() {
          _isLoginForm = true; // Switch view mode back to log in screen
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Registration failed.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon Header Node
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xff368983).withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(color: Color(0xff368983), shape: BoxShape.circle),
                    child: Icon(
                        _isLoginForm ? Icons.account_balance_wallet_rounded : Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: 45
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header text swaps dynamically
                Text(
                  _isLoginForm ? 'Log in' : 'Sign up',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 30),

                // USERNAME FIELD - Shows up only during Sign Up Mode
                if (!_isLoginForm) ...[
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Username', style: TextStyle(color: Color(0xff555555), fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5), borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xff368983), width: 2), borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Email Row Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email', style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xff368983), width: 2), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Row Input Field
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password', style: TextStyle(color: Colors.grey.shade700, fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5), borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xff368983), width: 2), borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // Dynamic Action Submission Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _handleSubmitAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff368983),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(_isLoginForm ? 'Log in' : 'Create Account', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 15),

                if (_isLoginForm) ...[
                  TextButton(
                    onPressed: () {
                      _showActionDialog('Reset Password', 'A password recovery feature requires an active SMTP email configuration script!');
                    },
                    child: Text('Forgot password?', style: TextStyle(color: Colors.grey.shade600, fontSize: 15)),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text('or', style: TextStyle(color: Colors.grey.shade500, fontSize: 15)),
                      ),
                      Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  OutlinedButton(
                    onPressed: () {
                      _showActionDialog('Google Authentication', 'Google Sign-In integration requires registering your application layout with Google Firebase console platforms!');
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 55),
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          'https://gstatic.com',
                          height: 24,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.g_mobiledata, size: 30, color: Colors.blue),
                        ),
                        const SizedBox(width: 12),
                        const Text('Log in with Google', style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                ],

                // Interactive Route Toggler
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        _isLoginForm ? "Don't have an account? " : "Already have an account? ",
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 15)
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isLoginForm = !_isLoginForm; // Instantly toggles entire display tree cleanly
                        });
                      },
                      child: Text(
                          _isLoginForm ? 'Sign up' : 'Sign in',
                          style: const TextStyle(color: Color(0xff368983), fontSize: 15, fontWeight: FontWeight.bold)
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
