import 'package:cloud_firestore/cloud_firestore.dart';

import '../../firebase_constants.dart';
import '../../models/either.dart';
import '../../models/failure.dart';
import '../../models/user_model.dart';

class UserRemoteDataSource {
  final FirebaseFirestore _firebaseFirestore;

  UserRemoteDataSource({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;
  Future<Either<Failure, UserModel>> saveUserModel({
    required UserModel userModel,
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConstants.users)
          .doc(userModel.id)
          .set(userModel.toJson());
      return Either.right(userModel);
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, UserModel>> updateUserModel({
    required UserModel userModel,
  }) async {
    try {
      await _firebaseFirestore
          .collection(FirebaseConstants.users)
          .doc(userModel.id)
          .update(userModel.toJson());
      return Either.right(userModel);
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, UserModel>> getUserModel({
    required String userId,
  }) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConstants.users)
          .doc(userId)
          .get();
      if (result.exists && result.data() != null) {
        return Either.right(
          UserModel.fromJson(result.data()!),
        );
      }
      return Either.left(Failure('User not found'));
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<int> getUserPiece() async {
    try {
      var allDocs =
          await _firebaseFirestore.collection(FirebaseConstants.users).get();
      int len = allDocs.docs.length;
      int userPiece = len % 4;
      return userPiece;
    } on Exception catch (_) {
      return 0;
    }
  }

  Future<Either<Failure, List<UserModel>>> getPieceOwnerUsers({
    required int piece,
    required int level,
  }) async {
    try {
      final result = await _firebaseFirestore
          .collection(FirebaseConstants.users)
          .where(UserModelKeys.pieces, arrayContains: piece)
          .get();
        final users = result.docs
            .where((doc) =>
                ((doc.data()[UserModelKeys.level] ?? 0) % 4) == (level % 4))
            .map((doc) => UserModel.fromJson(doc.data()))
            .toList();
        return Either.right(users);
      
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<bool> isSSNFound({
    required String ssn,
  }) async {
    try {
      final result =  await _firebaseFirestore
          .collection(FirebaseConstants.users)
          .where("${UserModelKeys.child}.${ChildModelKeys.ssn}", isEqualTo: ssn)
          .get();
      return result.docs.isNotEmpty;
    } on Exception catch (e) {
      return false;
    }
  }
}
