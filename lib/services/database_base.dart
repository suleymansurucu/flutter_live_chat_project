import '../model/user_model.dart';

abstract class DBBase{
  Future<bool> saveUser(UserModel userModel);

}