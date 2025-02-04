import 'package:cloud_firestore/cloud_firestore.dart';

class ChatOfPerson {
  final String sender;
  final String receiver;
  final bool seen_message;
  final DateTime? creat_at;
  final String last_message;
  final DateTime? seen_message_date;
  late String receiver_userName;
  late String receiver_profileUrl;

  ChatOfPerson({
    required this.sender,
    required this.receiver,
    required this.seen_message,
    required this.creat_at,
    required this.last_message,
    this.seen_message_date,
    this.receiver_userName = "Unknown",
    this.receiver_profileUrl = "https://www.example.com/default_avatar.png",
  });

  @override
  String toString() {
    return 'ChatOfPerson{sender: $sender, receiver: $receiver, '
        'seen_message: $seen_message, creat_at: $creat_at, last_message: $last_message,'
        ' seen_message_date: $seen_message_date}';
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'receiver': receiver,
      'seen_message': seen_message,
      'creat_at': creat_at != null ? Timestamp.fromDate(creat_at!) : FieldValue.serverTimestamp(),
      'last_message': last_message,
      'seen_message_date': seen_message_date,
    };
  }

  factory ChatOfPerson.fromMap(Map<String, dynamic> map) {
    return ChatOfPerson(
      sender: map['sender'] as String? ?? '',
      receiver: map['receiver'] as String? ?? '',
      seen_message: map['seen_message'] as bool? ?? false,
      creat_at: map['creat_at'] != null ? (map['creat_at'] as Timestamp).toDate() : null,
      last_message: map['last_message'] as String? ?? '',
      seen_message_date: map['seen_message_date'] != null ? (map['seen_message_date'] as Timestamp).toDate() : null,
      receiver_userName: map['receiver_userName'] as String? ?? "Unknown",
      receiver_profileUrl: map['receiver_profileUrl'] as String? ?? "https://www.example.com/default_avatar.png",
    );
  }
}
