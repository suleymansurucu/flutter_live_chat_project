import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/dart_items.dart';

class MyCustomBottomNavi extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> buildPage;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorsKeys;


  const MyCustomBottomNavi(
      {super.key, required this.currentTab, required this.onSelectedTab, required this.buildPage, required this.navigatorsKeys});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          bottomNavigationBarItem(TabItem.Users),
          bottomNavigationBarItem(TabItem.Profile)
        ], onTap: (index) => onSelectedTab(TabItem.values[index]),),

        tabBuilder: (context, index) {
          final showItem = TabItem.values[index];
          return CupertinoTabView(
            navigatorKey: navigatorsKeys[showItem],
              builder: (context){ return buildPage[showItem] ?? Container();});
        });
  }

  BottomNavigationBarItem bottomNavigationBarItem(TabItem tabItem) {
    final currenTab = TabItemData.allTabs[tabItem];

    return BottomNavigationBarItem(
        icon: Icon(currenTab?.icon), label: currenTab?.title.toString());
  }
}
