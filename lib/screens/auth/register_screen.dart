import 'dart:io';
import 'package:diacritic/diacritic.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/auth/login_screen.dart';
import 'package:dartarabic/dartarabic.dart';
import 'package:puzzle/screens/on_boarding/selection_screen.dart';

import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void register() {
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    if (image != null) {
      if (name.isNotEmpty && password.isNotEmpty) {
        registerWithPassword(name: name, password: password);
      } else {
        showSnackBar(context: context, content: "برجاء ملئ جميع الحقول");
      }
    } else {
      showSnackBar(context: context, content: "برجاء اختيار الصورة الشخصية");
    }
  }

  registerWithPassword({required String name, required String password}) async {
    showLoadingDialog(context);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: getEmail(name: name),
          password: password,
        )
            .then((userValue) async {
          storeFileToFirebase(uid: userValue.user!.uid, file: image!).then((downloadUrl) async {
            await userValue.user!.updateDisplayName(name);
            await userValue.user!.updatePhotoURL(downloadUrl);
            var allDocs = await FirebaseFirestore.instance.collection('users').get();
            int len = allDocs.docs.length;
            int userPiece = len % 4;
            FirebaseFirestore.instance.collection("users").doc(userValue.user!.uid).set({
              "uId": userValue.user!.uid,
              "profilePicture": downloadUrl,
              "name": name,
              "pieces": [userPiece],
              "userPiece": userPiece,
              "level": 0,
              "selection": {
                "0": 0,
                "1": 0,
                "2": 0,
              },
            }).then((value) {
              sharedPreferences.setString("id", FirebaseAuth.instance.currentUser!.uid);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectionScreen(),
                  ),
                  (route) => false);
            }).catchError((e) {
              Navigator.pop(context);
              showAwesomeDialog(context, e.toString());
            });
          }).catchError((e) {});
        }).catchError((e) {
          Navigator.pop(context);
          if (e.toString().contains("weak-password")) {
            showAwesomeDialog(context, "كلمة السر ضعيفة");
          } else if (e.toString().contains("email-already-in-use")) {
            showAwesomeDialog(context, "هذا الاسم مستخدم من قبل");
          } else if (e.code == 'invalid-email') {
            showAwesomeDialog(context, "البريد الالكتروني غير صحيح");
          } else {
            showAwesomeDialog(context, e.toString());
          }
        });
      }
    } on SocketException {
      Navigator.pop(context);
      showAwesomeDialog(context, "لا يوجد اتصال بالانترنت");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(),
            Positioned(
              top: 250,
              left: 0,
              child: Image.asset(Assets.assetsStar, width: 70, height: 70),
            ),
            Positioned(
              top: 450,
              right: 0,
              child: Image.asset(Assets.assetsStar, width: 60, height: 60),
            ),
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(Assets.assetsLogo, width: 100, height: 80),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(Assets.assetsStar, width: 50, height: 50),
                          const SizedBox(width: 30),
                          Text(
                            "معلومات الطفل",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 40,
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Stack(
                        children: [
                          image == null
                              ? const CircleAvatar(
                                  backgroundImage: AssetImage(Assets.assetsProfile),
                                  radius: 50,
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(
                                  Icons.add_a_photo_outlined,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            labelText: "الاسم",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          style: TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            labelText: "كلمة السر",
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        height: 170,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 145,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "تمتلك حساب؟",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 20,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const LoginScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "سجل دخول",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: register,
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 70),
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "انشاء",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getEmail({required String name}) {
    name = name.toLowerCase();
    name = name.replaceAll("ى", "ي");
    name = removeDiacritics(name);
    name = DartArabic.normalizeLetters(name);
    name = DartArabic.normalizeAlef(name);
    name = DartArabic.normalizeHamzaTasheel(name);
    name = DartArabic.normalizeHamzaUniform(name);
    name = DartArabic.normalizeLigature(name);
    name = DartArabic.stripShadda(name);
    name = DartArabic.stripTatweel(name);
    name = DartArabic.stripDiacritics(name);
    name = DartArabic.stripTashkeel(name);
    name = DartArabic.stripHarakat(name);
    String nameWithoutSpaces = name.replaceAll(' ', '');
    String numericString = '';
    for (int i = 0; i < nameWithoutSpaces.characters.length; i++) {
      int codePoint = nameWithoutSpaces.characters.elementAt(i).codeUnitAt(0);
      numericString += codePoint.toString();
    }
    numericString += "@example.com";
    return numericString;
  }
}
