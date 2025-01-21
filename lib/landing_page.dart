import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/home_page.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'model/user_model.dart';
import 'sign_in_page.dart';

class LandingPage extends StatefulWidget {

  final AuthBase authService;

  const LandingPage({super.key, required this.authService});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  var _user; // late kaldırıldı, nullable hale getirildi.

  @override
  void initState() {
    super.initState();
    _checkUser();
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return SignInPage(authService: widget.authService,onSignIn: (UserModel userModel) {
        _updateUser(userModel);
      });
    } else {
      return HomePage(authService: widget.authService, onSignOut: () { _updateUser(null); },);
    }
  }

  Future<void> _checkUser() async {
    var currentUser = widget.authService.currentUser();
    setState(() {
      _user = currentUser;
    });
  }

  void _updateUser(UserModel? user) {
    setState(() {
      _user = user;
    });
  }
}
