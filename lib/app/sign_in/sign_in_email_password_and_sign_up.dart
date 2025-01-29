import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/common_widget/social_log_in_button.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class SignInEmailPasswordAndSignUp extends StatefulWidget {
  const SignInEmailPasswordAndSignUp({super.key});

  @override
  State<SignInEmailPasswordAndSignUp> createState() =>
      _SignInEmailPasswordAndSignUpState();
}

class _SignInEmailPasswordAndSignUpState extends State<SignInEmailPasswordAndSignUp> {
  late String _email, _password;
  var _formType = FormType.LogIn;
  final _formKey = GlobalKey<FormState>();

  Future<void> _formSubmit(BuildContext context) async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final _userModel = Provider.of<UserViewModel>(context, listen: false);

      if (_formType == FormType.LogIn) {
        try{
          UserModel? _userLogInModel =
          await _userModel.signInWithEmailAndPassword(_email, _password);

          if (_userLogInModel != null) {
            print('Sign In user: ${_userLogInModel.userID}');
          } else {
            print('Error: Login failed');
          }
        }catch(e){
          print('catch an error in a sing in widget : $e');
        }

      } else {
        try{
          UserModel? _userCreateModel =
          await _userModel.createWithEmailAndPassword(_email, _password);

          if (_userCreateModel != null) {
            print('Sign Up user: ${_userCreateModel.userID}');
          } else {
            print('Error: Account creation failed');
          }
        }catch(e){
          print('catch an error in a sign up widget : $e');

        }
      }
    } else {
      print("Form is not valid!");
    }
  }

  void _changeTheTextOnForm() {
    setState(() {
      _formType = _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;

    });
  }

  @override
  Widget build(BuildContext context) {
    String _buttonText = _formType == FormType.Register ? 'Sign Up' : 'Sign In';
    String _linkText = _formType == FormType.LogIn
        ? 'Don’t have an account? Sign Up'
        : 'Already have an account? Sign In';


    final _userModel = Provider.of<UserViewModel>(context);

    // Ensure navigation happens after build is complete
    if (_userModel.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In with Email and Password'),
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: _userModel.state == ViewState.Idle ?
      SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email),
                      errorText: _userModel.emailErrorMessage,
                      hintText: 'Email',
                      labelText: 'Email',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onSaved: (text) {
                      _email = text!;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    obscureText: true,
                    decoration:  InputDecoration(
                      prefixIcon: Icon(Icons.password),
                      hintText: 'Password',
                      errorText: _userModel.passwordErrorMesseage,
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onSaved: (text) {
                      _password = text!;
                    },
                  ),
                  const SizedBox(height: 10),
                  SocialLogInButton(
                    buttonText: _buttonText,
                    buttonColor: Colors.purple,
                    textColor: Colors.white,
                    buttonIcon: const Icon(Icons.email),
                    onPressed: () => _formSubmit(context),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _changeTheTextOnForm,
                    child: Text(_linkText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ) : Center(child: CircularProgressIndicator(),),
    );
  }
}
