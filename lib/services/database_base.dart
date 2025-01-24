import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';


abstract class DBBase{
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel?> readUser(String userID);

}