import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/app/message_page.dart';
import 'package:flutter_chat_projects/model/chat_of_person.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
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
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    if (userViewModel.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Chats')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Chats'),
        backgroundColor: Colors.purple,
      ),
      body: FutureBuilder<List<ChatOfPerson>>(
        future: userViewModel.getAllConversations(userViewModel.user!.userID).then((value) => value ?? []), // ✅ null yerine boş liste dön
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    "An error occurred: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
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

          var allChats = snapshot.data!;

          return ListView.separated(
            itemCount: allChats.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              var thisChat = allChats[index];

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(thisChat.receiver_profileUrl),
                  radius: 25,
                ),
                title: Text(
                  thisChat.receiver_userName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  thisChat.last_message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () async {
                  // ✅ Receiver ID üzerinden Firestore'dan kullanıcıyı getir
                  UserModel? receiverUser = await userViewModel.getUserById(thisChat.receiver);

                  if (receiverUser != null) {
                    // ✅ Eğer kullanıcı bulunursa, sohbet sayfasına yönlendir
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MessagePage(
                          currentUser: userViewModel.user!,
                          textToUser: receiverUser, // ✅ `UserModel` gönderildi
                        ),
                      ),
                    );
                  } else {
                    // ❌ Kullanıcı bulunamazsa hata mesajı göster
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("User not found!")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
