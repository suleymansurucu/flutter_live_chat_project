import 'package:flutter_chat_projects/model/chat_of_person.dart';
import 'package:flutter_chat_projects/model/message_model.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/database_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreDBService implements DBBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel userModel) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userModel.userID)
        .set(userModel.toMap());

    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.doc('users/${userModel.userID}').get();
    Map<String, dynamic>? _readUserMap =
        documentSnapshot.data() as Map<String, dynamic>?;
    UserModel _readUserInformation = UserModel.fromMap(_readUserMap!);
    print(_readUserInformation.toString());

    return true;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot _readUser =
        await _firebaseFirestore.collection('users').doc(userID).get();
    Map<String, dynamic>? _readUserInformationMap =
        _readUser.data() as Map<String, dynamic>?;
    print({UserModel.fromMap(_readUserInformationMap!).toString()});
    return UserModel.fromMap(_readUserInformationMap);
  }

  @override
  Future<bool> updateUsername(String userID, String userName) async {
    var user = await _firebaseFirestore
        .collection('users')
        .where('userName', isEqualTo: userName)
        .get();

    if (user.docs.isNotEmpty) {
      return false;
    } else {
      await _firebaseFirestore
          .collection('users')
          .doc(userID)
          .update({'userName': userName});
      return true;
    }
  }

  @override
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL) async {
    await _firebaseFirestore
        .collection('users')
        .doc(userID)
        .update({'profilePhotoUrl': profilePhotoURL});
    return true;
  }

  @override
  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot querySnapshot =
        await _firebaseFirestore.collection('users').get();
    List<UserModel> allUsers = [];

    for (DocumentSnapshot user in querySnapshot.docs) {
      UserModel userModel =
          UserModel.fromMap(user.data() as Map<String, dynamic>);
      allUsers.add(userModel);
    }
    return allUsers;
  }

  @override
  Stream<List<MessageModel>> getMessages(
      String currentUserID, String textToUserID) {
    print('$currentUserID--$textToUserID');
    var snapShot = _firebaseFirestore
        .collection('chats')
        .doc('$currentUserID--$textToUserID')
        .collection('messages')
        .orderBy('dateTime')
        .snapshots();

    var listOfMessage = snapShot.map((listOfMessage) {
      var messages = listOfMessage.docs
          .map((text) => MessageModel.fromMap(text.data()))
          .toList();

      // Print each message
      for (var message in messages) {
        print(
            "Message: ${message.messageText}, From: ${message.fromText}, To: ${message.textTo}, Date: ${message.dateTime}");
      }

      return messages;
    });

    return listOfMessage;
  }

  Future<bool> saveMessage(MessageModel saveMessage) async {
    var messageID = _firebaseFirestore.collection('chats').doc().id;
    var myDocumentID = '${saveMessage.fromText}--${saveMessage.textTo}';
    var recieverUserID = '${saveMessage.textTo}--${saveMessage.fromText}';

    var saveMessageMap = saveMessage.toMap();
    await _firebaseFirestore.collection('chats').doc(myDocumentID).set({
      'sender': saveMessage.fromText,
      'receiver': saveMessage.textTo,
      'last_message': saveMessage.messageText,
      'seen_message': false,
      'creat_at': saveMessage.dateTime ?? Timestamp.now()
    });
    await _firebaseFirestore.collection('chats').doc(recieverUserID).set({
      'sender': saveMessage.textTo,
      'receiver': saveMessage.fromText,
      'last_message': saveMessage.messageText,
      'seen_message': false,
      'creat_at': saveMessage.dateTime ?? Timestamp.now()
    });

    await _firebaseFirestore
        .collection('chats')
        .doc(myDocumentID)
        .collection('messages')
        .doc(messageID)
        .set(saveMessageMap);
    saveMessageMap.update('whoTextTo', (value) => false);
    await _firebaseFirestore
        .collection('chats')
        .doc(recieverUserID)
        .collection('messages')
        .doc(messageID)
        .set(saveMessageMap);

    return true;
  }

  @override
  Future<List<ChatOfPerson>> getAllConversations(String currentUserID) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('chats')
        .where('sender', isEqualTo: currentUserID)
        .orderBy('creat_at', descending: true)
        .get();
    List<ChatOfPerson> allChatsofPerson = [];
    for (DocumentSnapshot onlyChat in querySnapshot.docs) {
      ChatOfPerson _onlyOneChatOfPerson =
          ChatOfPerson.fromMap(onlyChat.data() as Map<String, dynamic>);
      allChatsofPerson.add(_onlyOneChatOfPerson);
    }
    return allChatsofPerson;
  }

  @override
  Future<List<UserModel>> getUserWithPagination(UserModel? lastUser, int usersToRetrieve) async {
    QuerySnapshot querySnapshot;
    List<UserModel> allUsers = [];

    if (lastUser == null ) {
      print('First time user is coming');
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .limit(usersToRetrieve)
          .get();
    } else {
      print('Second time user is coming');
      querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('userName')
          .startAfter([lastUser.userName]) // Son kullanıcıya göre başla
          .limit(usersToRetrieve)
          .get();
    }

    for (DocumentSnapshot snapshot in querySnapshot.docs) {
      UserModel singleUser = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      allUsers.add(singleUser);
    }

    return allUsers;
  }
}
