import 'package:firebase_auth/firebase_auth.dart';
import 'package:puzzle/core/models/either.dart';
import 'package:puzzle/core/models/failure.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  Future<Either<Failure, User>> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return Either.right(user);
      } else {
        return Either.left(Failure('User not found'));
      }
    } on FirebaseAuthException catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        return Either.right(user);
      } else {
        return Either.left(Failure('User not found'));
      }
    } on FirebaseAuthException catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }

  Future<Either<Failure, Unit>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return Either.right(Unit());
    } on FirebaseAuthException catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
