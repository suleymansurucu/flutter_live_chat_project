import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_projects/app/message_page.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

import '../viewmodel/user_view_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<UserModel> allUsers = [];
  bool isLoading = false;
  bool hasMore = true;
  int getUserNumber = 10;
  UserModel? _getLastUser;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {        getMoreFetchUser();

    });

    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading) {
        getMoreFetchUser();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    final _userViewModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<AllUsersViewModel>(
          builder: (buildContext, allUsersViewModel, child) {
        if (_allUsersViewModel.state == AllUsersViewState.Busy) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (_allUsersViewModel.state == AllUsersViewState.Loaded) {
          return ListView.builder(
            itemCount: _allUsersViewModel.allUsersList.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index < allUsers.length) {
                if (allUsers[index].userID == _userViewModel.user!.userID) {
                  return SizedBox.shrink();
                }
                return createUserList(index);
              } else {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
            },
          );
        } else {
          return Container();
        }
      }),
    );
  }

/*  Future<void> getUser() async {
    final userModel = Provider.of<UserViewModel>(context, listen: false);

    if (!hasMore || isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      List<UserModel> users =
          await userModel.getUserWithPagination(_getLastUser, getUserNumber);

      if (users.isNotEmpty) {
        setState(() {
          allUsers.addAll(users);
          _getLastUser = allUsers.last;
        });
      } else {
        setState(() {
          hasMore = false;
        });
      }
    } catch (error) {
      print('Error fetching users: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget buildUserList() {
    final userModel = Provider.of<UserViewModel>(context, listen: false);

    return RefreshIndicator(
      onRefresh: refreshListOfUser,
      child: ListView.builder(
        itemCount: allUsers.length + (hasMore ? 1 : 0),
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < allUsers.length) {
            if (allUsers[index].userID == userModel.user!.userID) {
              return SizedBox.shrink();
            }
            return createUserList(index);
          } else {
            return Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget createUserList(int index) {
    final userModel = Provider.of<UserViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessagePage(
                currentUser: userModel.user as UserModel,
                textToUser: allUsers[index])));
      },
      child: Card(
        child: ListTile(
          title: Text(allUsers[index].userName.toString()),
          subtitle: Text(allUsers[index].email.toString()),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:
                NetworkImage(allUsers[index].profilePhotoUrl.toString()),
          ),
        ),
      ),
    );
  }

  Future<void> refreshListOfUser() async {
    setState(() {
      allUsers = [];
      _getLastUser = null;
      hasMore = true;
    });
    await getUser();
  }*/

  void getMoreFetchUser() {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context);
    _allUsersViewModel.getMoreFetchUser();
  }
  Widget createUserList(int index) {
    final userModel = Provider.of<UserViewModel>(context, listen: false);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessagePage(
                currentUser: userModel.user as UserModel,
                textToUser: allUsers[index])));
      },
      child: Card(
        child: ListTile(
          title: Text(allUsers[index].userName.toString()),
          subtitle: Text(allUsers[index].email.toString()),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage:
            NetworkImage(allUsers[index].profilePhotoUrl.toString()),
          ),
        ),
      ),
    );
  }

}
