import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/landing_page.dart';
import 'package:flutter_chat_projects/services/firebase_auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Live Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.purple,
      ),
      home: LandingPage(authService: FirebaseAuthService(),),
    );
  }
}
