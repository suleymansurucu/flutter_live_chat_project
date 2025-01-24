import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/dart_items.dart';
import 'package:flutter_chat_projects/app/my_custom_bottom_navi.dart';
import 'package:flutter_chat_projects/app/sign_in/profile_page.dart';
import 'package:flutter_chat_projects/app/users_page.dart';
import 'package:flutter_chat_projects/model/user_model.dart';

import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;

  const HomePage({
    super.key,
    required this.userModel,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Users;

  Map<TabItem, Widget> allPages() {
    return {TabItem.Users: UsersPage(), TabItem.Profile: ProfilePage()};
  }

  @override
  Widget build(BuildContext context) {
    return MyCustomBottomNavi(
        currentTab: _currentTab,
        buildPage: allPages(),
        onSelectedTab: (onSelectedTab) {
          print('Selected item is ${onSelectedTab.toString()}');
          setState(() {
            _currentTab = onSelectedTab;
          });
        });
  }
}

/*
Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.purple,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24),
        actions: [
          TextButton(
            onPressed: () => _signOut(context),
            child: const Text(
              "Sign Out",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: MyCustomBottomNavi(
          currentTab: _currentTab,
          buildPage: allPages(),
          onSelectedTab: (onSelectedTab) {
            print('Selected item is ${onSelectedTab.toString()}');
            setState(() {
              _currentTab = onSelectedTab;
            });
          }),
    );
  }

  Future<bool> _signOut(BuildContext context) async {
    final _userModel = Provider.of<UserViewModel>(context, listen: false);
    bool result = await _userModel.signOut();
    return result;
  }
 */
