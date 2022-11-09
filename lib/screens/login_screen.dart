import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';
import 'package:puzzle/screens/first_register_screen.dart';
import 'package:puzzle/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        showLoadingDialog(context);
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: email,
            password: password,
          )
              .then((userValue) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  const CallPickupScreen(scaffold: HomeScreen()),
                ),
                (route) => false);
          }).catchError((e) {
            Navigator.pop(context);
            if (e.code == 'user-not-found') {
              showAwesomeDialog(context, "لا يوجد حساب مرتبط بهذا البريد الالكتروني");
            } else if (e.code == 'wrong-password') {
              showAwesomeDialog(context, "كلمة السر غير صحيحة");
            }else if (e.code == 'invalid-email') {
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
    } else {
      showSnackBar(context: context, content: "برجاء ملئ جميع الحقول");
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
                            "تسجيل الدخول",
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
                      const Spacer(),
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
                                        "لا تمتلك حساب؟",
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
                                              builder: (context) => const FirstRegisterScreen(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "انشاء حساب",
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
                                onTap: login,
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
                                      "التالي",
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
}
