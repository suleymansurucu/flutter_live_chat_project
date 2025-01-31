import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);

    if (userViewModel.user == null) {
      return Scaffold(
        appBar: AppBar(title: Text('My Chats')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Chats'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder(
        future: userViewModel.getAllConversations(userViewModel.user!.userID),
        builder: (context, snapshot) {
          // 📌 Veri yüklenirken bekleme durumu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 📌 Hata oluşursa kullanıcıya göster
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "An error occurred, please try again.",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          // 📌 Eğer hiç sohbet yoksa
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No conversations yet.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // 📌 Veri varsa listeyi oluştur
          var allChats = snapshot.data!;

          return ListView.builder(
            itemCount: allChats.length,
            itemBuilder: (context, index) {
              var thisChat = allChats[index];

              return ListTile(
                title: Text(thisChat.last_message),
                subtitle: Text(thisChat.receiver_userName),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(thisChat.receiver_profileUrl)
                ),
              );
            },
          );
        },
      ),
    );
  }
}
