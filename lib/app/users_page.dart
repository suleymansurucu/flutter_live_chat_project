import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users',style: TextStyle(color: Colors.white, fontSize: 24),),
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: Text('Users Page'),
      ),
    );
  }
}
