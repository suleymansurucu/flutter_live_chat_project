import 'package:flutter_chat_projects/repository/user_repository.dart';
import 'package:flutter_chat_projects/services/firebase_auth_service.dart';
import 'package:flutter_chat_projects/services/test_auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => TestAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
}
