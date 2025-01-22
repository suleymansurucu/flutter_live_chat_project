import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

class TestAuthenticationService implements AuthBase{
  String userID= '12312312';
  @override
  Future<UserModel?> currentUser() {
    return Future.value(UserModel(userID: userID));
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 1), ()=> UserModel(userID: userID));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
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