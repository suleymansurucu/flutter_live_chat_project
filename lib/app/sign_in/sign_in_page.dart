import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/sign_in/sign_in_email_password_and_sign_up.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';
import '../../model/user_model.dart';
import '../../common_widget/social_log_in_button.dart';

class SignInPage extends StatelessWidget {
  Future<void> _signInGuest(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      UserModel? result = await _userViewModel.signInAnonymously();
      print(
          'You have opened account succesfully for USER ID: ${result?.userID}');
    } catch (e) {
      print("Error during guest sign in: $e");
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      UserModel? result = await _userViewModel.signInWithGoogle();
      print(
          'You have opened account succesfully for USER ID: ${result?.userID}');
    } catch (e) {
      print("Error during guest sign in: $e");
    }
  }

  void _signInEmailAndPassword(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SignInEmailPasswordAndSignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Chat'),
        elevation: 0,
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Please Sign In',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
            ),
            const SizedBox(height: 30),
            SocialLogInButton(
              buttonText: 'Log In with Google',
              textColor: Colors.black87,
              radius: 16,
              buttonColor: Colors.white,
              onPressed: () => _signInWithGoogle(context),
              buttonIcon: Image.asset('assets/images/google-logo.png'),
            ),
            SocialLogInButton(
              buttonText: 'Log In with Facebook',
              textColor: Colors.white,
              radius: 16,
              buttonColor: Colors.blue.shade700,
              onPressed: () {},
              buttonIcon: Image.asset('assets/images/facebook-logo.png'),
            ),
            SocialLogInButton(
              buttonText: 'Log In with Email and Password',
              textColor: Colors.white,
              radius: 16,
              buttonColor: Colors.purple.shade700,
              onPressed: () {
                _signInEmailAndPassword(context);
              },
              buttonIcon:
                  const Icon(Icons.email, size: 32, color: Colors.white),
            ),
            SocialLogInButton(
              buttonText: 'Log In as Guest',
              textColor: Colors.white,
              radius: 16,
              buttonColor: Colors.teal,
              onPressed: () => _signInGuest(context),
              // **context gönderildi**
              buttonIcon:
                  const Icon(Icons.account_box, size: 32, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
