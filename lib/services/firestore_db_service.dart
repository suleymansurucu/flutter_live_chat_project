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
    Map<String, dynamic>? _readUserMap = documentSnapshot.data() as Map<String, dynamic>?;
   UserModel _readUserInformation=UserModel.fromMap(_readUserMap!);
   print(_readUserInformation.toString());


    return true;
  }
}
