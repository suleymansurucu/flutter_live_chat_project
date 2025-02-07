import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import 'app/landing_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: MaterialApp(
        title: 'Live Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.purple,
        ),
        home: LandingPage(),
      ),
    );
  }
}
