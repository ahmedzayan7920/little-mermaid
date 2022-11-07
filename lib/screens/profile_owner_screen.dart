import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';

class ProfileOwnerScreen extends StatefulWidget {
  final String name;
  final String profilePicture;
  final String uid;
  final int pieceIndex;

  const ProfileOwnerScreen({
    Key? key,
    required this.pieceIndex,
    required this.name,
    required this.profilePicture,
    required this.uid,
  }) : super(key: key);

  @override
  State<ProfileOwnerScreen> createState() => _ProfileOwnerScreenState();
}

class _ProfileOwnerScreenState extends State<ProfileOwnerScreen> {
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
            Padding(
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
                        "هذه القطعة مع",
                        style: TextStyle(
                          fontSize: 40,
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.profilePicture),
                    radius: 150,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 40,
                    ),
                  ),
                  const Spacer(),
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
                          "اتصل به",
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
            )
          ],
        ),
      ),
    );
  }
}
