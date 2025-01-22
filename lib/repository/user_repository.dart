import 'package:flutter_chat_projects/locator.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'package:flutter_chat_projects/services/firebase_auth_service.dart';
import 'package:flutter_chat_projects/services/test_auth_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final TestAuthenticationService _testAuthService =
      locator<TestAuthenticationService>();

  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.currentUser();
    } else {
      return await _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async{
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInWithGoogle();
    } else {
      return await _firebaseAuthService.signInWithGoogle();
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(String email, String password) {
    // TODO: implement createWithEmailAndPassword
    throw UnimplementedError();
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement signInWithEmailAndPassword
    throw UnimplementedError();
  }
}
