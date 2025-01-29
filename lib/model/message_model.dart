import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel{
   final String fromText;
   final String textTo;
   final bool whoTextTo;
   final String messageText;
    final DateTime? dateTime;

  MessageModel({required this.fromText, required this.textTo, required this.whoTextTo, required this.messageText, this.dateTime});

   Map<String, dynamic> toMap() {
    return {
      'fromText': fromText,
      'textTo': textTo,
      'whoTextTo': whoTextTo,
      'messageText': messageText,
      'dateTime': dateTime ?? FieldValue.serverTimestamp(),
    };
  }



   factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      fromText: map['fromText'] as String,
      textTo: map['textTo'] as String,
      whoTextTo: map['whoTextTo'] as bool,
      messageText: map['messageText'] as String,
      dateTime: (map['dateTime'] as Timestamp).toDate(),
    );
  }

   @override
   String toString() {
     return 'MessageModel{fromText: $fromText, textTo: $textTo, whoTextTo: $whoTextTo, messageText: $messageText, dateTime: $dateTime}';
   }
}