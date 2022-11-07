import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';
import 'package:puzzle/screens/profile_owner_screen.dart';

class PieceOwnerScreen extends StatefulWidget {
  final int pieceIndex;

  const PieceOwnerScreen({
    Key? key,
    required this.pieceIndex,
  }) : super(key: key);

  @override
  State<PieceOwnerScreen> createState() => _PieceOwnerScreenState();
}

class _PieceOwnerScreenState extends State<PieceOwnerScreen> {
  late Query<Map<String, dynamic>> ref;

  @override
  void initState() {
    ref = FirebaseFirestore.instance.collection('users').where("pieces", arrayContains: widget.pieceIndex);
    // ref = FirebaseFirestore.instance.collection('users');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    Expanded(
                      child: StreamBuilder(
                          stream: ref.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List data = snapshot.data!.docs;
                              if (data.isNotEmpty) {
                                return ListView.separated(
                                  itemCount: data.length,
                                  separatorBuilder: (_, i) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> child = data[index].data();
                                    return InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfileOwnerScreen(
                                              pieceIndex: widget.pieceIndex,
                                              name: child["name"],
                                              profilePicture: child["profilePicture"],
                                              uid: child["uId"],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 6),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: AppColors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: NetworkImage(child["profilePicture"]),
                                            radius: 25,
                                          ),
                                          title: Text(
                                            child["name"],
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 25,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "لا أحد يمتلك تلك القطعة",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: AppColors.white,
                                    ),
                                  ),
                                );
                              }
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            } else {}
                            return const Center(child: Text("Error"));
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
