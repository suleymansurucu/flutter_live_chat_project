import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      return UserModel(userID: user.uid, email:user.email);
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
      final _googleSingIn = GoogleSignIn();
      await _googleSingIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Error signing out: $e');
      return false;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        var authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = authResult.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user); // Doğru tipte döndürülüyor
    } catch (e) {
      print('Firebase Auth Service Error create in emailAndPassword: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user); // Doğru tipte döndürülüyor
    } catch (e) {
      print('Firebase Auth Service Error signing in emailAndPassword: $e');
      return null;
    }
  }
}
