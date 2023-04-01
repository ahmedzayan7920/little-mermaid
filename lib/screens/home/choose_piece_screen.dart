import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/home/home_screen.dart';

class ChoosePieceScreen extends StatefulWidget {
  final int pieceIndex;
  final int level;
  final String uId;

  const ChoosePieceScreen({
    Key? key,
    required this.pieceIndex,
    required this.level,
    required this.uId,
  }) : super(key: key);

  @override
  State<ChoosePieceScreen> createState() => _ChoosePieceScreenState();
}

class _ChoosePieceScreenState extends State<ChoosePieceScreen> {
  List places = [];
  int? selectedIndex;
  int colorIndex = 0;

  generateList() {
    int n = generateNumber();
    if (!places.contains(n)) {
      places.add(n);
    }
    if (places.length != 4) {
      generateList();
    }
  }

  int generateNumber() {
    return Random().nextInt(4);
  }

  @override
  void initState() {
    generateList();
    super.initState();
  }

  sendPiece() async {
    if (selectedIndex != places.indexOf(widget.pieceIndex)) {
      showAwesomeDialog(context, "قم باختيار الصورة الصحيحة");
    } else {
      showLoadingDialog(context);
      await FirebaseFirestore.instance.collection("users").doc(widget.uId).update({
        'pieces': FieldValue.arrayUnion([widget.pieceIndex]),
      });
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .doc(widget.uId)
          .delete();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
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
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(Assets.assetsStar, width: 50, height: 50),
                      const SizedBox(width: 10),
                      Text(
                        "اختر القطعة",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 40,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 60,
                          crossAxisSpacing: 3,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          int position = places[index];
                          if (position == widget.pieceIndex) {
                            return Container(
                              padding: index == 0
                                  ? const EdgeInsets.only(bottom: 30, right: 30)
                                  : index == 1
                                      ? const EdgeInsets.only(top: 30, left: 30)
                                      : index == 2
                                          ? const EdgeInsets.only(bottom: 30, left: 30)
                                          : const EdgeInsets.only(top: 30, left: 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.buttonColor,
                                    width: selectedIndex == index ? 5 : 0,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Image.asset(
                                    "assets/${widget.level % 2}$position.jpeg",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            colorIndex++;
                            return Container(
                              padding: index == 0
                                  ? const EdgeInsets.only(bottom: 30, right: 30)
                                  : index == 1
                                      ? const EdgeInsets.only(top: 30, left: 30)
                                      : index == 2
                                          ? const EdgeInsets.only(bottom: 30, left: 30)
                                          : const EdgeInsets.only(top: 30, left: 30),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.buttonColor,
                                    width: selectedIndex == index ? 5 : 0,
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Image.asset(
                                      "assets/${(colorIndex % 3) + 1}.jpeg",
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: selectedIndex == null ? null : sendPiece,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Text(
                          "ارسال القطعة",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
        ),
      ),
    );
  }
}
