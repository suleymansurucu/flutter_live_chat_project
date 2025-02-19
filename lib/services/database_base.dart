
import '../model/chat_of_person.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';


abstract class DBBase{
  Future<bool> saveUser(UserModel userModel);
  Future<UserModel?> readUser(String userID);

  Future<bool> updateUsername(String userID,String userName);
  Future<bool> updateProfilePhoto(String userID, String profilePhotoURL);
  Future<List<UserModel>> getAllUsers();

  Future<List<UserModel>>getUserWithPagination(UserModel lastUser, int usersToRetrieve);
  Stream<List<MessageModel>> getMessages(String currentUserID, String textToUserID);
  Future<bool> saveMessage(MessageModel saveMessage);
  Future<List<ChatOfPerson>> getAllConversations(String currentUserID);


}