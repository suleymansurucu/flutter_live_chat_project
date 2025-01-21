import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print('Error getting current user: $e');
      return null;
    }
  }

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    } else {
      return UserModel(userID: user.uid);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user); // Doğru tipte döndürülüyor
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }
}
