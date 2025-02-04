import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_projects/app/message_page.dart';
import 'package:flutter_chat_projects/viewmodel/all_users_view_model.dart';
import 'package:provider/provider.dart';

import '../viewmodel/user_view_model.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late ScrollController scrollController;
  bool isFetching = false;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      getMoreFetchUser();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200 &&
          !isFetching) {
        getMoreFetchUser();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void getMoreFetchUser() async {
    final _allUsersViewModel = Provider.of<AllUsersViewModel>(context, listen: false);
    if (isFetching || _allUsersViewModel.state == AllUsersViewState.Busy) return;

    setState(() {
      isFetching = true;
    });

     _allUsersViewModel.getMoreFetchUser();

    setState(() {
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.purple,
      ),
      body: Consumer<AllUsersViewModel>(
        builder: (context, allUsersViewModel, child) {
          if (allUsersViewModel.state == AllUsersViewState.Busy && allUsersViewModel.allUsers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: allUsersViewModel.allUsers.length + 1,
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index < allUsersViewModel.allUsers.length) {
                return createUserList(index, allUsersViewModel);
              } else if (allUsersViewModel.state == AllUsersViewState.Busy) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }

  Widget createUserList(int index, AllUsersViewModel viewModel) {
    final userModel = Provider.of<UserViewModel>(context, listen: false);
    final user = viewModel.allUsers[index];

    if (user.userID == userModel.user!.userID) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MessagePage(
                currentUser: userModel.user!,
                textToUser: user)));
      },
      child: Card(
        child: ListTile(
          title: Text(user.userName!),
          subtitle: Text(user.email!),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(user.profilePhotoUrl.toString()),
          ),
        ),
      ),
    );
  }
}
