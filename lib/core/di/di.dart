import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:puzzle/core/data_sources/remote/user_local_data_source.dart';
import 'package:puzzle/core/data_sources/remote/user_remote_data_source.dart';
import 'package:puzzle/core/repos/storage_repository.dart';
import 'package:puzzle/core/repos/user_repository.dart';
import 'package:puzzle/core/services/call_service.dart';
import 'package:puzzle/features/auth/repos/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

setupDependencyInjection() async {
  // Register services
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );
  getIt.registerLazySingleton<FirebaseAuth>(
    () => FirebaseAuth.instance,
  );

  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<FirebaseStorage>(
    () => FirebaseStorage.instance,
  );

  getIt.registerLazySingleton<CallService>(
    () => CallService(),
  );


  // Register data sources
  getIt.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSource(sharedPreferences: getIt()),
  );
  getIt.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSource(firebaseFirestore: getIt()),
  );

  // Register repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepository(
      userLocalDataSource: getIt(),
      userRemoteDataSource: getIt(),
    ),
  );

  getIt.registerLazySingleton<StorageRepository>(
    () => StorageRepository(
      firebaseStorage: getIt(),
    ),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(
      firebaseAuth: getIt(),
    ),
  );
}
