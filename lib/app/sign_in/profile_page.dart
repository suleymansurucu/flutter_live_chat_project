import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_view_model.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.purple,
        actions: [
          TextButton(
            child: Text('Sign Out'),
            onPressed: () {
              _signOut(context);
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.purple.shade400,
              // Arka plan rengi
              foregroundColor: Colors.white,
              // Yazı rengi
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              // İç boşluk
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              // Yazı tipi
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Kenarları yuvarlat
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
}
