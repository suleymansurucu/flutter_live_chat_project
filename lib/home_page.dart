import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

class HomePage extends StatefulWidget {
  final AuthBase authService;
  final VoidCallback onSignOut;

  const HomePage({super.key, required this.onSignOut, required this.authService});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<UserModel?> _user;

  @override
  void initState() {
    super.initState();
    _user = widget.authService.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        actions: [
          TextButton(
            onPressed: () async {
              print("Sign Out");
              await _signOut();
            },
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<UserModel?>(
          future: _user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const Text('Error loading user');
            }
            return Text('Welcome ${snapshot.data!.userID}');
          },
        ),
      ),
    );
  }

  Future<bool> _signOut() async {
    bool result = await widget.authService.signOut();
    widget.onSignOut();
    return result;
  }
}
