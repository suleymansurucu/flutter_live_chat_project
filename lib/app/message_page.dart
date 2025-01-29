import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/model/message_model.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/viewmodel/user_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel textToUser;

  const MessagePage(
      {super.key, required this.currentUser, required this.textToUser});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();
    final _userModel = Provider.of<UserViewModel>(context);
    var currentUser = widget.currentUser;
    var textToUser = widget.textToUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Page',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 5,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageModel>>(
              stream:
                  _userModel.getMessages(currentUser.userID, textToUser.userID),
              builder: (context, streamMessageList) {
                if (!streamMessageList.hasData ||
                    streamMessageList.data!.isEmpty) {
                  print('Buradayim');
                  return Center(
                      child: Text("No messages yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey)));
                } else {
                  var allMessages = streamMessageList.data;
                  return ListView.builder(
                    controller: scrollController,
                    itemCount: allMessages!.length,
                    itemBuilder: (context, index) {
                      return buildTalkBalloon(allMessages[index]);
                    },
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    cursorColor: Colors.grey,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      hintText: "Type your message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  elevation: 3,
                  backgroundColor: Colors.blueAccent,
                  onPressed: () async {
                    if (_messageController.text.trim().isNotEmpty) {
                      MessageModel saveMessage = MessageModel(
                        fromText: currentUser.userID,
                        textTo: textToUser.userID,
                        whoTextTo: true,
                        messageText: _messageController.text,
                      );
                      bool result = await _userModel.saveMessage(saveMessage);
                      if (result) {
                        _messageController.clear();
                        scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 10),
                            curve: Curves.easeOut);
                      }
                    }
                  },
                  child: Icon(
                    Icons.send,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTalkBalloon(MessageModel allMessage) {
   var hourAndMinuteShowValue= _hourAndMinuteShow(allMessage.dateTime);
    
    
    print(
        "Message received: ${allMessage.messageText}, whoTextTo: ${allMessage.whoTextTo}");
    var isSender = allMessage.whoTextTo;
    if (isSender) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Align(
          alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSender ? Colors.blue.shade300 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  child: Text(
                    allMessage.messageText,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSender ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              Text(hourAndMinuteShowValue),
            ],
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.textToUser.profilePhotoUrl!),
              ),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isSender ? Colors.blue.shade300 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(4),
                  child: Text(
                    allMessage.messageText,
                    style: TextStyle(
                      fontSize: 16,
                      color: isSender ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              ),
              Text(hourAndMinuteShowValue),
            ],
          )
        ],
      );
    }
  }

  String _hourAndMinuteShow(DateTime? dateTime) {
    var format = DateFormat("hh:mm a");
    var dateString = format.format(dateTime!);
    return dateString;

  }
}
