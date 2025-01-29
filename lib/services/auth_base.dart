import 'package:flutter_chat_projects/model/user_model.dart';

abstract class AuthBase {
   Future<UserModel?> currentUser();
   Future<UserModel?> signInAnonymously();
   Future<bool> signOut();
   Future<UserModel?>signInWithGoogle();
   Future<UserModel?>signInWithEmailAndPassword(String email, String password);
   Future<UserModel?>createWithEmailAndPassword(String email, String password);

}
