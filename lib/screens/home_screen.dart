import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/piece_owner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String name;
  late String profilePicture;
  late List pieces;

  final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(),
            Positioned(
              bottom: 20,
              left: 0,
              child: Image.asset(Assets.assetsStar, width: 50, height: 35),
            ),
            Positioned(
              bottom: 0,
              left: 30,
              child: Image.asset(Assets.assetsStar, width: 50, height: 25),
            ),
            FutureBuilder(
                future: ref.get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    name = snapshot.data!.data()!["name"];
                    profilePicture = snapshot.data!.data()!["profilePicture"];
                    pieces = snapshot.data!.data()!["pieces"];
                    return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(Assets.assetsStar, width: 50, height: 50),
                              const SizedBox(width: 10),
                              Text(
                                "ملفي الشخصي",
                                style: TextStyle(
                                  fontSize: 40,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              height: double.infinity,
                              child: Stack(
                                children: [
                                  LayoutBuilder(builder: (context, constraints) {
                                    return Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        height: constraints.maxHeight - 80,
                                        decoration: BoxDecoration(
                                          color: AppColors.white,
                                          borderRadius: BorderRadius.circular(40),
                                        ),
                                      ),
                                    );
                                  }),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 30, left: 30, right: 30),
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(profilePicture),
                                            radius: 80,
                                          ),
                                          Text(
                                            name,
                                            style: TextStyle(
                                              color: AppColors.textColor,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Divider(
                                            thickness: 2,
                                            color: AppColors.primary,
                                            indent: 10,
                                            endIndent: 10,
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
                                                  mainAxisSpacing: 3,
                                                  crossAxisSpacing: 3,
                                                  childAspectRatio: 1,
                                                ),
                                                itemBuilder: (BuildContext context, int index) {
                                                  if (pieces.contains(index)) {
                                                    return Image.asset(
                                                      "assets/smile${index + 1}.png",
                                                      width: 50,
                                                      height: 50,
                                                    );
                                                  } else {
                                                    return InkWell(
                                                      onTap: () async {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (_) => PieceOwnerScreen(pieceIndex: index),
                                                          ),
                                                        );
                                                        // await FirebaseFirestore.instance
                                                        //     .collection('users')
                                                        //     .doc("q0IFWs8MVwMiOvsmnTYwno4aKLo2")
                                                        //     .update({
                                                        //   'pieces': FieldValue.arrayUnion([index]),
                                                        // });
                                                        // setState(() {
                                                        //
                                                        // });
                                                      },
                                                      child: Image.asset(
                                                        "assets/empty${index + 1}.png",
                                                        width: 50,
                                                        height: 50,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
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
                                  "الطلبات",
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
          ],
        ),
      ),
    );
  }
}
