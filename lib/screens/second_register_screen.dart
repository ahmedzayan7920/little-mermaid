import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';
import 'package:puzzle/screens/home_screen.dart';
import 'package:puzzle/screens/login_screen.dart';

class SecondRegisterScreen extends StatefulWidget {
  final File image;
  final String childName;
  final String childSsn;
  final String childBirthDate;
  final String childCity;

  const SecondRegisterScreen({
    Key? key,
    required this.image,
    required this.childName,
    required this.childSsn,
    required this.childBirthDate,
    required this.childCity,
  }) : super(key: key);

  @override
  State<SecondRegisterScreen> createState() => _SecondRegisterScreenState();
}

class _SecondRegisterScreenState extends State<SecondRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    ssnController.dispose();
    emailController.dispose();
    passwordController.dispose();
    birthDateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  registerWithEmailAndPassword({required String email, required String password}) async {
    showLoadingDialog(context);
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: email,
          password: password,
        )
            .then((userValue) async {
          await userValue.user!.updateDisplayName(widget.childName);
          storeFileToFirebase(uid: userValue.user!.uid, file: widget.image).then((downloadUrl) async {
            var allDocs = await FirebaseFirestore.instance.collection('users').get();
            int len = allDocs.docs.length;
            int userPiece = len % 4;
            FirebaseFirestore.instance.collection("users").doc(userValue.user!.uid).set({
              "uId": userValue.user!.uid,
              "profilePicture": downloadUrl,
              "name": widget.childName,
              "pieces": [userPiece],
              "userPiece": userPiece,
            }).then((value) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  const CallPickupScreen(scaffold: HomeScreen()),
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
            showAwesomeDialog(context, "The Password is too weak");
          } else if (e.toString().contains("email-already-in-use")) {
            showAwesomeDialog(context, "The account already exists for that email");
          } else {
            showAwesomeDialog(context, e.toString());
          }
        });
      }
    } on SocketException {
      Navigator.pop(context);
      showAwesomeDialog(context, "No Internet Connection");
    }
  }

  void register() {
    String name = nameController.text.trim();
    String ssn = ssnController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String birtDate = birthDateController.text.trim();
    String city = cityController.text.trim();

    if (name.isNotEmpty &&
        ssn.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        birtDate.isNotEmpty &&
        city.isNotEmpty) {
      registerWithEmailAndPassword(email: email, password: password);
    } else {
      showSnackBar(context: context, content: "برجاء ملئ جميع الحقول");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: LayoutBuilder(builder: (context, constraint) {
          return Stack(
            children: [
              const CustomBackground(),
              Positioned(
                top: 250,
                left: 0,
                child: Image.asset(Assets.assetsStar, width: 60, height: 60),
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
                            const SizedBox(width: 20),
                            Text(
                              "معلومات ولي الأمر",
                              style: TextStyle(
                                fontSize: 40,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: nameController,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الاسم الثلاثي",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: ssnController,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الرقم القومي",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "البريد الالكتروني",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: passwordController,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "كلمة السر",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: birthDateController,
                            onTap: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime.now(),
                              );
                              if (newDate == null) return;
                              setState(() {
                                birthDateController.text =
                                    "${newDate.year.toString()}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
                              });
                            },
                            readOnly: true,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "تاريخ الميلاد",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: cityController,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "المحافظة",
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
                                      child: Text(
                                        "انشاء حساب",
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
