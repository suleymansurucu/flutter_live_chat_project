import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/model/user_model.dart';

import '../locator.dart';
import '../repository/user_repository.dart';

enum AllUsersViewState { Idle, Error, Loaded, Busy }

class AllUsersViewModel with ChangeNotifier {
  AllUsersViewState allUsersViewState = AllUsersViewState.Idle;
  late List<UserModel> allUsers;
  UserModel? _lastFetchedUsers;

  List<UserModel> get allUsersList => allUsers;

  AllUsersViewState get state => allUsersViewState;

  static final int getUserNumber = 10;
  final UserRepository _userRepository = locator<UserRepository>();

  set state(AllUsersViewState value) {
    allUsersViewState = value;
    notifyListeners();
  }

  AllUsersViewModel() {
    allUsers = [];
    _lastFetchedUsers = null;
    getUserWithPagination(_lastFetchedUsers);
  }

  getUserWithPagination(UserModel? lastFetchedUsers) async {
    if (allUsersList.isNotEmpty) {
      _lastFetchedUsers=allUsersList.last;
      print('En son getirilen username' +_lastFetchedUsers!.userName.toString());
    }
    state=AllUsersViewState.Busy;
    allUsers = await _userRepository.getUserWithPagination(
        lastFetchedUsers, getUserNumber);


    state=AllUsersViewState.Loaded;
  }

  void getMoreFetchUser() {
    print('Get More Fetch User...');
    getUserWithPagination(_lastFetchedUsers);
  }
}
