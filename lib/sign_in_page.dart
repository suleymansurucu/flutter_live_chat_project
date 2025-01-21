import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'model/user_model.dart';
import 'home_page.dart';

import 'common_widget/social_log_in_button.dart';

class SignInPage extends StatelessWidget {
  final Function(UserModel) onSignIn;
  final AuthBase authService;

  const SignInPage({super.key, required this.onSignIn, required this.authService});

  Future<void> _signInGuest(BuildContext context) async {

    try {

      UserModel? result = await authService.signInAnonymously();
      onSignIn(result!);

      if (result != null) {
        print('The user ID for the opened account is: ${result.userID}');
        onSignIn(result);

        /// **Ana sayfaya yönlendirme işlemi burada yapılır.**
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(authService: authService, onSignOut: () {}),
          ),
        );
      } else {
        print("Sign in failed");
      }
    } catch (e) {
      print("Error during guest sign in: $e");
    }
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
              onPressed: () {},
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
              onPressed: () {},
              buttonIcon: const Icon(Icons.email, size: 32, color: Colors.white),
            ),
            SocialLogInButton(
              buttonText: 'Log In as Guest',
              textColor: Colors.white,
              radius: 16,
              buttonColor: Colors.teal,
              onPressed: () => _signInGuest(context), // **context gönderildi**
              buttonIcon: const Icon(Icons.account_box, size: 32, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
