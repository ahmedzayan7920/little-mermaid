import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';
import 'package:puzzle/screens/choose_piece_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late Query<Map<String, dynamic>> ref;

  @override
  void initState() {
    ref = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orders");
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(Assets.assetsStar, width: 50, height: 50),
                        const SizedBox(width: 10),
                        Text(
                          "الطلبات",
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
                      child: StreamBuilder(
                          stream: ref.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List data = snapshot.data!.docs;
                              if (data.isNotEmpty) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "الاسم",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          "رقم القطعة",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.white,
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: data.length,
                                        separatorBuilder: (context, i) => const SizedBox(height: 8),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> order = data[index].data();
                                          return Container(
                                            padding: const EdgeInsets.symmetric(vertical: 6),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                color: AppColors.white,
                                                width: 2,
                                              ),
                                            ),
                                            child: ListTile(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ChoosePieceScreen(
                                                      pieceIndex: order["pieceIndex"],
                                                      uId: order["uId"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              title: Text(
                                                order["name"],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 25,
                                                ),
                                              ),
                                              trailing: Text(
                                                "${order["pieceIndex"] + 1}",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 25,
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Center(
                                  child: Text(
                                    "لا يوجد طلبات",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
                            return const Center(
                              child: Text(
                                "حدث خطا برجاء المحاولة لاحقا",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }),
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
      ),
    );
  }
}
