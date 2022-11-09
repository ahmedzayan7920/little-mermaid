import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/models/call_model.dart';
import 'package:puzzle/screens/call_screen.dart';

class CallPickupScreen extends StatefulWidget {
  final Widget scaffold;

  const CallPickupScreen({
    Key? key,
    required this.scaffold,
  }) : super(key: key);

  @override
  State<CallPickupScreen> createState() => _CallPickupScreenState();
}

class _CallPickupScreenState extends State<CallPickupScreen> {
  final ref = FirebaseFirestore.instance.collection("calls").doc(FirebaseAuth.instance.currentUser!.uid);

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("calls").doc(callerId).delete();
      await FirebaseFirestore.instance.collection("calls").doc(receiverId).delete();
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
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
              bottom: 20,
              left: 0,
              child: Image.asset(Assets.assetsStar, width: 50, height: 35),
            ),
            Positioned(
              bottom: 0,
              left: 30,
              child: Image.asset(Assets.assetsStar, width: 50, height: 25),
            ),
            StreamBuilder<DocumentSnapshot>(
              stream: ref.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.data() != null) {
                  CallModel call = CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
                  if (!call.hasDialled) {
                    print("----------------------------------");
                    print(call.callerPicture);
                    print("----------------------------------");
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Incoming Call",
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 50),
                          CircleAvatar(
                            radius: 100,
                            backgroundImage: CachedNetworkImageProvider(call.callerPicture),
                          ),
                          const SizedBox(height: 50),
                          Text(
                            call.callerName,
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => endCall(
                                  context: context,
                                  callerId: call.callerId,
                                  receiverId: call.receiverId,
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.call_end,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 25),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CallScreen(
                                        channelId: call.callId,
                                        call: call,
                                        isGroupChat: false,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.call,
                                    color: Colors.green,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  }
                }
                return widget.scaffold;
              },
            ),
          ],
        ),
      ),
    );
  }
}
