import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/common_widget/social_log_in_button.dart';

class SignInEmailPasswordAndSignUp extends StatefulWidget {
  const SignInEmailPasswordAndSignUp({super.key});

  @override
  State<SignInEmailPasswordAndSignUp> createState() =>
      _SignInEmailPasswordAndSignUpState();
}

class _SignInEmailPasswordAndSignUpState
    extends State<SignInEmailPasswordAndSignUp> {
  late String _email, _password;
  final _formKey=GlobalKey<FormState>();

  void _formSubmit(context) {
    if (_formKey.currentState != null) {
      _formKey.currentState!.save();
    } else {
      print("Error: _formKey.currentState is null");
    }  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign In with Email and Password'),
          backgroundColor: Colors.purple,
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
              child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                    labelText: 'Email',
                    border: OutlineInputBorder()),
                onSaved: (text) {
                  _email = text!;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.password),
                    hintText: 'Password',
                    labelText: 'Password',
                    border: OutlineInputBorder()),
                onSaved: (text) {
                  _password = text!;
                },
              ),
              SizedBox(
                height: 10,
              ),
              SocialLogInButton(
                  buttonText: 'Sign In',
                  buttonColor: Colors.purple,
                  textColor: Colors.white,
                  buttonIcon: Icon(Icons.email),
                  onPressed: (){if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  } else {
                    print("Form is not valid!");
                  }}),
              SizedBox(
                height: 12,
              ),
              TextButton(onPressed: (){}, child: Text('Already your Account? You can click for Sing Up')),
            ],
          )),
        )));
  }

}
