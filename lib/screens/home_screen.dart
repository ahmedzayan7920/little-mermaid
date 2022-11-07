import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';
import 'package:puzzle/screens/login_screen.dart';
import 'package:puzzle/screens/orders_screen.dart';
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
    double buttonWidth = MediaQuery.of(context).size.width - 120;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CallPickupScreen(
        scaffold: Scaffold(
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
              StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final user = snapshot.data!.data();
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
                                              backgroundImage: NetworkImage(user!["profilePicture"]),
                                              radius: 80,
                                            ),
                                            Text(
                                              user["name"],
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
                                                    if (user["pieces"].contains(index)) {
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
                                                              builder: (_) =>
                                                                  PieceOwnerScreen(pieceIndex: index),
                                                            ),
                                                          );
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
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            user["pieces"].contains(0) &&
                                    user["pieces"].contains(1) &&
                                    user["pieces"].contains(2) &&
                                    user["pieces"].contains(3)
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showLoadingDialog(context);
                                          FirebaseFirestore.instance
                                              .collection("users")
                                              .doc(FirebaseAuth.instance.currentUser!.uid)
                                              .update({
                                            'pieces': [user["userPiece"]],
                                          }).then((value) {
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Expanded(
                                          child: Container(
                                            height: 50,
                                            width: (buttonWidth / 2) - 3,
                                            decoration: BoxDecoration(
                                              color: AppColors.buttonColor,
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(30),
                                                bottomRight: Radius.circular(30),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "اعادة اللعبة",
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const OrdersScreen(),
                                            ),
                                          );
                                        },
                                        child: Expanded(
                                          child: Container(
                                            height: 50,
                                            width: (buttonWidth / 2) - 3,
                                            decoration: BoxDecoration(
                                              color: AppColors.buttonColor,
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30),
                                              ),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "الطلبات",
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const OrdersScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: buttonWidth,
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
                  }),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      });
                    },
                    icon: const Icon(Icons.logout),
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
