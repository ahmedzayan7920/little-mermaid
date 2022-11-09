import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

void showSnackBar({
  required BuildContext context,
  required String content,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (error) {
    showSnackBar(context: context, content: error.toString());
  }

  return image;
}

showAwesomeDialog(context, text) {
  return AwesomeDialog(
    context: context,
    body: Text(text, style: const TextStyle(fontSize: 24)),
    dismissOnBackKeyPress: false,
    dismissOnTouchOutside: false,
    btnCancel: TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("اغلاق"),
    ),
  ).show();
}

showLoadingDialog(context) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return const AlertDialog(
        title: Text("برجاء الانتظار", textAlign: TextAlign.end),
        content: SizedBox(
          width: 80,
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

Future<String> storeFileToFirebase(
    {required String uid, required File file}) async {
  UploadTask uploadTask = FirebaseStorage.instance.ref().child("profilePic/$uid").putFile(file);
  // uploadTask.snapshotEvents.listen((event) {
  //   print(((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()) *100).roundToDouble());
  // });
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  return downloadUrl;
}
