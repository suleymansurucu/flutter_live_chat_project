import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/model/user_model.dart';

import '../locator.dart';
import '../repository/user_repository.dart';

enum AllUsersViewState { Idle, Error, Loaded, Busy }

class AllUsersViewModel with ChangeNotifier {
  AllUsersViewState allUsersViewState = AllUsersViewState.Idle;
  List<UserModel> allUsers = [];
  UserModel? _lastFetchedUsers;

  final UserRepository _userRepository = locator<UserRepository>();
  static const int getUserNumber = 10;

  AllUsersViewState get state => allUsersViewState;

  set state(AllUsersViewState value) {
    allUsersViewState = value;
    notifyListeners();
  }

  AllUsersViewModel() {
    getUserWithPagination(null);
  }

  Future<void> getUserWithPagination(UserModel? lastFetchedUsers) async {
    if (allUsers.isNotEmpty) {
      _lastFetchedUsers = allUsers.last;
    }

    state = AllUsersViewState.Busy;

    List<UserModel> fetchedUsers = await _userRepository.getUserWithPagination(
        lastFetchedUsers, getUserNumber);

    if (fetchedUsers.isNotEmpty) {
      allUsers.addAll(fetchedUsers);
      _lastFetchedUsers = fetchedUsers.last;
    }

    state = AllUsersViewState.Loaded;
  }

  void getMoreFetchUser() {
    getUserWithPagination(_lastFetchedUsers);
  }
}
