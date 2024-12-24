import 'dart:convert';
import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/either.dart';
import '../../models/failure.dart';
import '../../models/user_model.dart';

class UserLocalDataSource {
  final SharedPreferences _sharedPreferences;

  UserLocalDataSource({
    required SharedPreferences sharedPreferences,
  }) : _sharedPreferences = sharedPreferences;

  Future<Either<Failure, UserModel>> saveUserModel({
    required UserModel userModel,
  }) async {
    try {
      await _sharedPreferences.setString(
        'userModel',
        json.encode(userModel.toJson()),
      );
      return Either.right(userModel);
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, UserModel>> updateUserModel({
    required UserModel userModel,
  }) async {
    log('**** from local update updateUserModel: $userModel');
    try {
      await _sharedPreferences.setString(
        'userModel',
        json.encode(userModel.toJson()),
      );
      log('**** from update local success: ${userModel.toJson()}');
      return Either.right(userModel);
    } on Exception catch (e) {
      log('**/** updateUserModel: $userModel');
      return Either.left(Failure.fromException(e));
    }
  }

  Either<Failure, UserModel> getLocalCurrentUserModel() {
    try {
      final result = _sharedPreferences.getString(
        'userModel',
      );
      if (result == null) {
        return Either.left(Failure('User not found'));
      } else {
        final userModel = UserModel.fromJson(json.decode(result));
        return Either.right(userModel);
      }
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, Unit>> deleteLocalUserModel() async {
    try {
      await _sharedPreferences.remove('userModel');
      return Either.right(Unit());
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
