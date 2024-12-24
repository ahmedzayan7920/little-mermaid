import 'dart:developer';

import '../data_sources/remote/user_local_data_source.dart';
import '../data_sources/remote/user_remote_data_source.dart';
import '../models/either.dart';
import '../models/failure.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserLocalDataSource _userLocalDataSource;
  final UserRemoteDataSource _userRemoteDataSource;

  UserRepository({
    required UserLocalDataSource userLocalDataSource,
    required UserRemoteDataSource userRemoteDataSource,
  })  : _userLocalDataSource = userLocalDataSource,
        _userRemoteDataSource = userRemoteDataSource;

  Future<Either<Failure, UserModel>> saveUserModel({
    required UserModel userModel,
  }) async {
    final userPiece = await _userRemoteDataSource.getUserPiece();
    final newUser = userModel.copyWith(
      userPiece: userPiece,
      pieces: [userPiece],
    );
    final remoteResult =
        await _userRemoteDataSource.saveUserModel(userModel: newUser);
    return remoteResult.fold(
      (failure) => Either.left(failure),
      (userModel) async {
        final localResult =
            await _userLocalDataSource.saveUserModel(userModel: userModel);
        return localResult.fold(
          (failure) => Either.left(failure),
          (userModel) => Either.right(userModel),
        );
      },
    );
  }

  Future<Either<Failure, UserModel>> updateUserModel({
    required UserModel userModel,
  }) async {
    final remoteResult =
        await _userRemoteDataSource.updateUserModel(userModel: userModel);
    return remoteResult.fold(
      (failure) {
        log('**** failure from update remote failure: ${failure.message}');
        return Either.left(failure);
      },
      (userModel) async {
        final localResult =
            await _userLocalDataSource.updateUserModel(userModel: userModel);
        return localResult.fold(
          (failure) {
            log('**** failure from update local failure: ${failure.message}');
            return Either.left(failure);
          },
          (userModel) => Either.right(userModel),
        );
      },
    );
  }

  Either<Failure, UserModel> getLocalCurrentUserModel() {
    return _userLocalDataSource.getLocalCurrentUserModel();
  }

  Future<Either<Failure, UserModel>> getRemoteCurrentUserModel({
    required String userId,
  }) async {
    final remoteResult =
        await _userRemoteDataSource.getUserModel(userId: userId);
    return remoteResult.fold(
      (failure) => Either.left(failure),
      (userModel) async {
        final localResult =
            await _userLocalDataSource.saveUserModel(userModel: userModel);
        return localResult.fold(
          (failure) => Either.left(failure),
          (userModel) => Either.right(userModel),
        );
      },
    );
  }

  Future<Either<Failure, List<UserModel>>> getPieceOwnerUsers({
    required int piece,
    required int level,
  }) {
    return _userRemoteDataSource.getPieceOwnerUsers(piece: piece, level: level);
  }

  Future<Either<Failure, Unit>> deleteLocalUserModel() {
    return _userLocalDataSource.deleteLocalUserModel();
  }

  Future<bool> isSSNFound({required String ssn}) {
    return _userRemoteDataSource.isSSNFound(ssn: ssn);
  }

}
