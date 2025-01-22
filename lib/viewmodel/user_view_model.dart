import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_projects/locator.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/repository/user_repository.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    notifyListeners();
  }

  final UserRepository _userRepository = locator<UserRepository>();
  UserModel? _user;

  UserModel? get user => _user;

  set user(UserModel? value) {
    _user = value;
  }

  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      if (_user == null) {
        print('User is null');
        return null;
      }
      return _user;
    } catch (e) {
      print('Error in ViewModel Current User: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = (await _userRepository.signInAnonymously())!;
      return _user;
    } catch (e) {
      print('Error in ViewModel Current User: $e');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      _user = null;
      return await _userRepository.signOut();
    } catch (e) {
      print('Error in ViewModel Current User: $e');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async{
    try {
      state = ViewState.Busy;
      _user = (await _userRepository.signInWithGoogle())!;
      return _user;
    } catch (e) {
      print('Error in ViewModel Current User: $e');
      return null;
    } finally {
      state = ViewState.Idle;
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