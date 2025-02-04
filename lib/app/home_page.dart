import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/dart_items.dart';
import 'package:flutter_chat_projects/app/my_custom_bottom_navi.dart';
import 'package:flutter_chat_projects/app/profile_page.dart';
import 'package:flutter_chat_projects/app/users_page.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

import 'chats_page.dart';

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
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  TabItem _currentTab = TabItem.Users;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Users: GlobalKey<NavigatorState>(),
    TabItem.Profile: GlobalKey<NavigatorState>(),
    TabItem.Chats: GlobalKey<NavigatorState>()
  };

  Map<TabItem, Widget> allPages() {
    return {
      TabItem.Users: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AllUsersViewModel(),
          ),
        ],
        child: UsersPage(),
      ),
      TabItem.Profile: ProfilePage(),
      TabItem.Chats: ChatsPage()
    };
  }

  @override
  void initState() {
    pushNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: MyCustomBottomNavi(
          currentTab: _currentTab,
          navigatorsKeys: navigatorKeys,
          buildPage: allPages(),
          onSelectedTab: (onSelectedTab) {
            print('Selected item is ${onSelectedTab.toString()}');
            setState(() {
              _currentTab = onSelectedTab;
            });
          }),
    );
  }

  void pushNotification() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔔 Bildirim izni verildi!");
    } else {
      print("❌ Bildirim izni reddedildi.");
    }

    _firebaseMessaging.subscribeToTopic('all');

    String? token = await _firebaseMessaging.getToken();
    print("🔑 Firebase Token: $token");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Yeni bildirim alındı: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          "📲 Bildirime tıklandı ve uygulama açıldı: ${message.notification?.title}");
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
