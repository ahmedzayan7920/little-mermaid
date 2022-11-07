import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call_pickup_screen.dart';

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
    // ref = FirebaseFirestore.instance.collection('users').where("pieces", arrayContains: widget.pieceIndex);
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
                                return Expanded(
                                  child: ListView.separated(
                                    itemCount: data.length,
                                    separatorBuilder: (_, i) => const SizedBox(height: 8),
                                    itemBuilder: (_, index) {
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
                                          leading: Text(
                                            "${order["pieceIndex"] + 1}",
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 25,
                                            ),
                                          ),
                                          title: Text(
                                            order["name"],
                                            style: TextStyle(
                                              color: AppColors.white,
                                              fontSize: 25,
                                            ),
                                          ),
                                          trailing: ElevatedButton(
                                            onPressed: () {
                                              showLoadingDialog(context);
                                              FirebaseFirestore.instance
                                                  .collection("users")
                                                  .doc(order["uId"])
                                                  .update({
                                                'pieces': FieldValue.arrayUnion([order["pieceIndex"]]),
                                              }).then((value) {
                                                FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                                    .collection("orders")
                                                    .doc(order["uId"])
                                                    .delete()
                                                    .then((value) {
                                                  Navigator.pop(context);
                                                });
                                              });
                                            },
                                            child: const Text(
                                              "ارسال",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return  Center(
                                  child: Text(
                                    "لا يوجد طلبات",
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
