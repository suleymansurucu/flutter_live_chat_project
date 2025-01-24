import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem { Users, Profile }

class TabItemData {
  final String title;
  final IconData icon;

  const TabItemData({
    required this.title,
    required this.icon,
  });

  static Map<TabItem, TabItemData> allTabs ={
    TabItem.Users : TabItemData(title: 'Users', icon: Icons.supervised_user_circle_sharp),
    TabItem.Profile : TabItemData(title: 'Profile', icon: Icons.person)
  };
}
