import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/main.dart';

import '../../background.dart';
import '../../core/app_colors.dart';
import '../../generated/assets.dart';
import '../call/call_pickup_screen.dart';
import '../home/home_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  int currentIndex = 0;
  num rate = 0;
  bool isLoading = false;

  List images = [
    Assets.onBoarding1,
    Assets.onBoarding2,
    Assets.onBoarding3,
    Assets.onBoarding4,
  ];

  @override
  void initState() {
    super.initState();
    FirebaseDatabase.instance.ref().onValue.listen((event) {
      setState(() {
        rate = (event.snapshot.value as Map)["rate"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(),
            CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        Assets.assetsLogo,
                        width: 100,
                        height: 80,
                      ),
                      const Spacer(),
                      Image.asset(
                        images[currentIndex],
                        width: width,
                        height: width,
                        fit: BoxFit.fitWidth,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        rate.toString(),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(top: 50),
                        height: 105,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: AppColors.white,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(50),
                                    topRight: Radius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: InkWell(
                                onTap: rate == 0 || isLoading
                                    ? null
                                    : () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(FirebaseAuth.instance.currentUser!.uid)
                                            .set(
                                          {
                                            "rate": {"$currentIndex": rate},
                                          },
                                          SetOptions(merge: true),
                                        ).then((value) {
                                          FirebaseDatabase.instance.ref().update({"rate": 0}).then((value) {
                                            if (currentIndex < (images.length - 1)) {
                                              setState(() {
                                                isLoading = false;
                                                currentIndex++;
                                              });
                                            } else if (currentIndex == (images.length - 1)) {
                                              sharedPreferences.setString(
                                                  "id", FirebaseAuth.instance.currentUser!.uid);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const CallPickupScreen(scaffold: HomeScreen()),
                                                  ),
                                                  (route) => false);
                                            }
                                          }).catchError((error) {
                                          });
                                        }).catchError((error) {
                                        });
                                      },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(horizontal: 70),
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: isLoading
                                            ? CircularProgressIndicator(color: AppColors.primary)
                                            : FittedBox(
                                                fit: BoxFit.fitHeight,
                                                child: Text(
                                                  currentIndex == (images.length - 1) ? "انهاء" : "التالي",
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
                                    rate == 0
                                        ? Container(
                                            height: 50,
                                            width: double.infinity,
                                            margin: const EdgeInsets.symmetric(horizontal: 70),
                                            decoration: BoxDecoration(
                                              color: AppColors.grey.withOpacity(0.5),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
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
