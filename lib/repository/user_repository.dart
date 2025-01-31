import 'dart:io';

import 'package:flutter_chat_projects/locator.dart';
import 'package:flutter_chat_projects/model/chat_of_person.dart';
import 'package:flutter_chat_projects/model/message_model.dart';
import 'package:flutter_chat_projects/model/user_model.dart';
import 'package:flutter_chat_projects/services/auth_base.dart';
import 'package:flutter_chat_projects/services/firebase_auth_service.dart';
import 'package:flutter_chat_projects/services/firebase_storage_service.dart';
import 'package:flutter_chat_projects/services/test_auth_service.dart';

import '../services/firestore_db_service.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final TestAuthenticationService _testAuthService =
      locator<TestAuthenticationService>();
  final FireStoreDBService _fireStoreDBService = locator<FireStoreDBService>();
  final FirebaseStorageService _firebaseStorageService =
      locator<FirebaseStorageService>();

  AppMode appMode = AppMode.RELEASE;
   List<UserModel> allUsersList=[];

  @override
  Future<UserModel?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.currentUser();
    } else {
      UserModel? userModel = await _firebaseAuthService.currentUser();
      return await _fireStoreDBService.readUser(userModel!.userID);
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInAnonymously();
    } else {
      UserModel? userModel = await _firebaseAuthService.signInAnonymously();
      bool _result = await _fireStoreDBService.saveUser(userModel!);
      if (_result) {
        return userModel;
      } else {
        return null;
      }
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInWithGoogle();
    } else {
      UserModel? _user = await _firebaseAuthService.signInWithGoogle();

      if (_user != null) {
        // Firestore'da kullanıcı var mı kontrol et
        UserModel? existingUser =
            await _fireStoreDBService.readUser(_user.userID);

        if (existingUser != null) {
          // Kullanıcı zaten kayıtlı, üzerine yazmadan giriş yap
          return existingUser;
        } else {
          // Kullanıcı yeni, kaydet
          bool _sonuc = await _fireStoreDBService.saveUser(_user);
          if (_sonuc) {
            return await _fireStoreDBService.readUser(_user.userID);
          } else {
            // Kullanıcı kaydedilemezse oturumu kapat
            await _firebaseAuthService.signOut();
            return null;
          }
        }
      } else {
        return null;
      }
    }
  }

  @override
  Future<UserModel?> createWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.createWithEmailAndPassword(email, password);
    } else {
      try {
        UserModel? userModel = await _firebaseAuthService
            .createWithEmailAndPassword(email, password);
        bool _result = await _fireStoreDBService.saveUser(userModel!);
        if (_result) {
          return await _fireStoreDBService.readUser(userModel.userID);
        } else {
          return null;
        }
      } catch (e) {
        print(
            'Catch error in repo Create WithEmailAndPassword ${e.toString()}');
      }
    }
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    if (appMode == AppMode.DEBUG) {
      return await _testAuthService.signInWithEmailAndPassword(email, password);
    } else {
      try {
        UserModel? _userModel = await _firebaseAuthService
            .signInWithEmailAndPassword(email, password);
        return _fireStoreDBService.readUser(_userModel!.userID);
      } catch (e) {
        print('Catch error in repo singInWithEmailAndPassword ${e.toString()}');
      }
    }
  }

  Future<bool?> updateUserName(String userID, String userName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      try {
        return await _fireStoreDBService.updateUsername(userID, userName);
      } catch (e) {
        print('Catch error in repo singInWithEmailAndPassword ${e.toString()}');
      }
    }
  }

  Future<String?> uploadFile(String userID, String fileType, File file) async {
    if (appMode == AppMode.DEBUG) {
      return '';
    } else {
      try {
        var result =
            await _firebaseStorageService.uploadFile(userID, fileType, file);
        await _fireStoreDBService.updateProfilePhoto(userID, result);
        return result;
      } catch (e) {
        print('Catch error in repo singInWithEmailAndPassword ${e.toString()}');
        return e.toString();
      }
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      try {
        allUsersList = await _fireStoreDBService.getAllUsers();

        return allUsersList;
      } catch (e) {
        print('Catch error in repo singInWithEmailAndPassword ${e.toString()}');
        return [];
      }
    }
  }

  Stream<List<MessageModel>> getMessages(
      String currentUserID, String textToUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      try {
        return _fireStoreDBService.getMessages(currentUserID, textToUserID);
      } catch (e) {
        print('Catch error in user repo get Messages ${e.toString()}');
        return Stream.empty();
      }
    }
  }

  Future<bool> saveMessage(MessageModel saveMessage) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      try {
        return _fireStoreDBService.saveMessage(saveMessage);
      } catch (e) {
        print('Catch error in user repo get Messages ${e.toString()}');
        return false;
      }
    }
  }

  Future<List<ChatOfPerson>?> getAllConversations(String currentUserID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      try {
        var chatUserList = await _fireStoreDBService.getAllConversations(currentUserID);

        // Eğer boşsa doğrudan boş liste döndür
        if (chatUserList.isEmpty) {
          return [];
        }

        // Debug için verileri yazdır
        print("Debug: Firebase'den gelen sohbetler: $chatUserList");

        for (var onlyChat in chatUserList) {
          var userListUsername = findUserInMyChat(onlyChat.receiver);

          if (userListUsername != null) {
            onlyChat.receiver_userName = userListUsername.userName ?? "Unknown User";

            // Eğer profil fotoğrafı null veya boşsa, varsayılan URL ata
            onlyChat.receiver_profileUrl = (userListUsername.profilePhotoUrl != null && userListUsername.profilePhotoUrl!.isNotEmpty)
                ? userListUsername.profilePhotoUrl!
                : "https://www.example.com/default_avatar.png"; // 🔹 Varsayılan URL
          } else {
            print('User not found for receiver: ${onlyChat.receiver}');
            onlyChat.receiver_userName = "Unknown User";
            onlyChat.receiver_profileUrl = "https://www.example.com/default_avatar.png"; // ✅ Varsayılan URL
          }
        }

        // ✅ Döngü tamamlandıktan sonra listeyi dön
        return chatUserList;

      } catch (e) {
        print('Error in getAllConversations: ${e.toString()}');
        return null; // Hata durumunda `null` döndür
      }
    }
  }


  UserModel? findUserInMyChat(String userID) {
    for (int i = 0; i < allUsersList.length; i++) {
      if (allUsersList[i].userID == userID) {
        return allUsersList[i];
      } else {
        return null;
      }
    }
  }

 Future<List<UserModel>> getUserWithPagination(UserModel? getLastUser, int getUserNumber) async{
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      try {
        return await _fireStoreDBService.getUserWithPagination(getLastUser, getUserNumber);
      } catch (e) {
        print('Catch error in user repo get Messages ${e.toString()}');
        return [];
      }
    }
  }
}
