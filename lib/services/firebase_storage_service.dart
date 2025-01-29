import 'dart:io';

import 'package:flutter_chat_projects/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';



class FirebaseStorageService implements StorageBase{

  final firebaseStorage = FirebaseStorage.instance;
  late Reference storageRef;


  @override
  Future<String> uploadFile(String userID, String fileType, File file)async {

    try {
      // Firebase Storage referansı oluştur
      Reference storageRef = FirebaseStorage.instance.ref().child(userID).child(fileType);

      // Dosyayı yükle
      UploadTask uploadTask = storageRef.putFile(file);

      // Yükleme tamamlanmasını bekle ve download URL'yi al
      TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
      String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print("Dosya yüklenirken hata oluştu: $e");
      return "";
    }
  }

}