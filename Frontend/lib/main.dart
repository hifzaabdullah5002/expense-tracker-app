import 'dart:io'; // REQUIRED: For bypassing local SSL certificate errors
import 'package:flutter/material.dart';
import 'package:hifza_expense_tracker/Screens/home.dart';
import 'package:hifza_expense_tracker/Screens/login_screen.dart';
import 'package:hifza_expense_tracker/Screens/statistics.dart';
import 'package:hifza_expense_tracker/widgets/bottomnavigationbar.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'data/model/add_date.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // REQUIRED: Tells the app to ignore SSL certificate validation for local testing
  HttpOverrides.global = MyHttpOverrides();

  await Hive.initFlutter();
  Hive.registerAdapter(AdddataAdapter());
  await Hive.openBox<Add_data>('data');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

// Custom HttpOverrides class to handle unverified local https connections
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
