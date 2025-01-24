import 'package:flutter_chat_projects/locator.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'package:flutter_chat_projects/services/firebase_auth_service.dart';
import 'package:flutter_chat_projects/services/test_auth_service.dart';

import '../services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final TestAuthenticationService _testAuthService =
      locator<TestAuthenticationService>();
  final FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();

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
      UserModel? userModel = await _firebaseAuthService.signInAnonymously();
      bool _result = await _fireStoreDBService.saveUser(userModel!);
      if (_result) {
        return userModel;
      } else {
        return null;
      }
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
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInWithGoogle();
    } else {
      UserModel? userModel = await _firebaseAuthService.signInWithGoogle();
      bool _result = await _fireStoreDBService.saveUser(userModel!);
      if (_result) {
        return await _fireStoreDBService.readUser(userModel.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.createWithEmailAndPassword(email, password);
    } else {
      UserModel? userModel = await _firebaseAuthService
          .createWithEmailAndPassword(email, password);
      bool _result = await _fireStoreDBService.saveUser(userModel!);
      if (_result) {
        return await _fireStoreDBService.readUser(userModel.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInWithEmailAndPassword(email, password);
    } else {
      UserModel? _userModel= await _firebaseAuthService.signInWithEmailAndPassword(
          email, password);
      return _fireStoreDBService.readUser(_userModel!.userID);
    }
  }
}
