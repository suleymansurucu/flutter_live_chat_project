import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

//TODO : Change This Class name to Mock or Fake
class TestAuthenticationService implements AuthBase{
  String userID= '12312312';
  @override
  Future<UserModel?> currentUser() {
    return Future.value(UserModel(userID: userID,email:'test@test.com'));
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    return await Future.delayed(Duration(seconds: 1), ()=> UserModel(userID: userID,email:'test@test.com'));
  }

  @override
  Future<bool> signOut() {
    return Future.value(true);
  }

  @override
  Future<UserModel> signInWithGoogle() async{
    return await Future.delayed(Duration(seconds: 1), ()=> UserModel(userID: 'google_user_id : 123456',email:'test@test.com'));
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(String email, String password) async{
    return await Future.delayed(Duration(seconds: 1), ()=> UserModel(userID: 'created_user_id : 123456',email:'test@test.com'));

  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email, String password) async{
    return await Future.delayed(Duration(seconds: 1), ()=> UserModel(userID: 'signed_user_id : 123456',email:'test@test.com'));

  }


}