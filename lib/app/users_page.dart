import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/message_page.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:provider/provider.dart';

import '../viewmodel/user_view_model.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    UserViewModel _userViewModel = Provider.of<UserViewModel>(context);
    _userViewModel.getAllUsers();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
        title: Text(
          'Users',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<UserModel>>(
          future: _userViewModel.getAllUsers(),
          builder: (context, result) {
            if (result.hasData) {
              var allUsers = result.data;
              if (allUsers!.isNotEmpty) {
                return ListView.builder(
                    itemCount: allUsers.length,
                    itemBuilder: (context, index) {
                      if (result.data![index].userID ==
                          _userViewModel.user!.userID) {
                        return SizedBox();
                      } else {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true)
                                .push(MaterialPageRoute(
                              builder: (context) => MessagePage(currentUser: _userViewModel.user!, textToUser: result.data![index],),
                            ));
                          },
                          child: ListTile(
                            title:
                                Text(result.data![index].userName.toString()),
                            subtitle:
                                Text(result.data![index].email.toString()),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                result.data![index].profilePhotoUrl.toString(),
                              ),
                            ),
                          ),
                        );
                      }
                    });
              } else {
                return Center(
                  child: Text('Dont have any user'),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
