import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/model/user_model.dart';

import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  final UserModel userModel;

  const HomePage({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Welcome ${_userModel.user!.userID}'),
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
