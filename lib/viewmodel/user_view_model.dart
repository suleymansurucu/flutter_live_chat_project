import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat_projects/locator.dart';
import 'package:flutter_chat_projects/model/chat_of_person.dart';
import 'package:flutter_chat_projects/model/message_model.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/repository/user_repository.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  String? emailErrorMessage;
  String? passwordErrorMesseage;

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
  Future<UserModel?> signInWithGoogle() async {
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
  Future<UserModel?> createWithEmailAndPassword(String email,
      String password) async {
    try {
      if (_emailAndPasswordCheck(email, password)) {
        state = ViewState.Busy;
        _user = (await _userRepository.createWithEmailAndPassword(
            email, password))!;
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error in ViewModel CreateWithEmailAndPassword : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(String email,
      String password) async {
    try {
      if (_emailAndPasswordCheck(email, password)) {
        state = ViewState.Busy;
        _user = (await _userRepository.signInWithEmailAndPassword(
            email, password))!;
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      print('Error in ViewModel SingInWithEmailAndPassword : ${e.toString()}');
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailAndPasswordCheck(String? email, String? password) {
    var result = true;
    if (password!.length < 6) {
      passwordErrorMesseage = 'Least minimum 6 characters';
      result = false;
    } else {
      passwordErrorMesseage = null;
    }
    if (!email!.contains('@')) {
      emailErrorMessage =
      'Invalid Email, Please enter correctly your email address';
      result = false;
    } else {
      emailErrorMessage = null;
    }
    return result;
  }

  Future<bool?> updateUsername(String userID, String userName) async {
   var result= await  _userRepository.updateUserName(userID,userName);
    return result;
  }
  Future<String?> uploadFile(String userID, String fileType, File file) async {
    var result= await  _userRepository.uploadFile(userID,fileType,file);
    return result;
  }
  Future<List<UserModel>> getAllUsers()async{
    var allUsersList= await _userRepository.getAllUsers();
    return allUsersList;
  }

 Stream<List<MessageModel>> getMessages(String currentUserID, String textToUserID) {
    return _userRepository.getMessages(currentUserID,textToUserID);
 }

  Future<bool> saveMessage(MessageModel saveMessage) {
    return _userRepository.saveMessage(saveMessage);
  }

  Future<List<ChatOfPerson>?> getAllConversations(String currentUserID) async{
    return await _userRepository.getAllConversations(currentUserID);
  }

  Future<List<UserModel>> getUserWithPagination(UserModel? getLastUser, int getUserNumber) async{
    return await _userRepository.getUserWithPagination(  getLastUser, getUserNumber);
  }
  Future<UserModel?> getUserById(String userID) async {
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();

      if (userDoc.exists) {
        return UserModel.fromMap(userDoc.data()!);
      }
    } catch (e) {
      print("Error fetching user by ID: $e");
    }
    return null;
  }

}
