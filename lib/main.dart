import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:wallapp/auth/auth.dart';
import 'package:wallapp/auth/login_or_register.dart';
import 'package:wallapp/firebase_options.dart';
import 'package:wallapp/pages/login_page.dart';
import 'package:wallapp/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: AuthPage());
  }
}
