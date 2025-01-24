import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userID;

  String? email;
  String? userName;
  String? profilePhotoUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? rolesLevel;

  UserModel({required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ?? email!.substring(0, email!.indexOf('@'))+buildRandomNumber() ,
      'profilePhotoUrl': profilePhotoUrl ?? '',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'rolesLevel': rolesLevel ?? 1
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilePhotoUrl = map['profilePhotoUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        rolesLevel = map['rolesLevel'];

  @override
  String toString() {
    return 'UserModel{userID: $userID, email: $email, userName: $userName, profilePhotoUrl: $profilePhotoUrl, createdAt: $createdAt, updatedAt: $updatedAt, rolesLevel: $rolesLevel}';
  }

  String buildRandomNumber() {
    int randemNumber = Random().nextInt(999999);
    return randemNumber.toString();
  }
}
