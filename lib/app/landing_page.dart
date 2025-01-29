import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/home_page.dart';
import 'package:flutter_chat_projects/app/sign_in/sign_in_page.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel =  Provider.of<UserViewModel>(context);
    if (userModel.state == ViewState.Idle) {
      if (userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(userModel: userModel.user!);
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
