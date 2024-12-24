import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../models/either.dart';
import '../models/failure.dart';

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({
    required FirebaseStorage firebaseStorage,
  }) : _firebaseStorage = firebaseStorage;

  Future<Either<Failure, String>> uploadFile({
    required String refPath,
    required String imagePath,
  }) async {
    try {
      UploadTask uploadTask = _firebaseStorage
          .ref()
          .child(refPath)
          .putFile(File(imagePath));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return Either.right(downloadUrl);
    } on Exception catch (e) {
      return Either.left(Failure.fromException(e));
    }
  }
}
