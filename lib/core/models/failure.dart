import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class Failure {
  final String message;

  const Failure(this.message);

  factory Failure.fromException(dynamic e) {
    if (e is FirebaseAuthException) {
      if (e.toString().contains("weak-password")) {
        return Failure("كلمة السر ضعيفة");
      } else if (e.toString().contains("email-already-in-use")) {
        return Failure("هذا البريد الالكتروني مستخدم من قبل");
      } else if (e.code == 'invalid-email') {
        return Failure("البريد الالكتروني غير صحيح");
      } else if (e.code == 'user-not-found') {
        return Failure("لا يوجد حساب مرتبط بهذا البريد الالكتروني");
      } else if (e.code == 'wrong-password') {
        return Failure("كلمة السر غير صحيحة");
      } else {
        return Failure(e.message ?? e.toString());
      }
    } else if (e is FirebaseException) {
      return Failure(e.message ?? e.toString());
    } else if (e is SocketException) {
      return Failure('لا يوجد اتصال بالانترنت');
    } else if (e is PathNotFoundException) {
      return Failure(e.message);
    } else {
      return Failure(e.toString());
    }
  }
}
