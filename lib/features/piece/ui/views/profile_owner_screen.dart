import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../../core/di/di.dart';
import '../../../../core/firebase_constants.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/services/call_service.dart';
import '../../../auth/logic/auth_cubit.dart';

class ProfileOwnerScreen extends StatefulWidget {
  final int piece;
  final UserModel pieceOwner;

  const ProfileOwnerScreen({
    super.key,
    required this.piece,
    required this.pieceOwner,
  });

  @override
  State<ProfileOwnerScreen> createState() => _ProfileOwnerScreenState();
}

class _ProfileOwnerScreenState extends State<ProfileOwnerScreen> {
  late int level;

  @override
  void initState() {
    super.initState();
    level = BlocProvider.of<AuthCubit>(context).currentUserModel!.level;
    setAudio();
  }

  final audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/audio/");
  bool isPlaying = true;

  @override
  void dispose() {
    audioPlayer.dispose();
    player.clearAll();
    super.dispose();
  }

  Future setAudio() async {
    final url = await player.load("6.mp3");
    audioPlayer.play(UrlSource(url.path));
    setState(() {
      isPlaying = true;
    });
    audioPlayer.onPlayerComplete.listen((state) {
      setState(() {
        isPlaying = false;
      });
    });
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
                  const Spacer(),
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        widget.pieceOwner.child.profilePicture),
                    radius: 150,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.pieceOwner.child.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 40,
                    ),
                  ),
                  const Spacer(),
                  ZegoSendCallInvitationButton(
                    isVideoCall: true,
                    resourceID: "zegouikit_call",
                    customData:
                        '{"callerAvatar": "${BlocProvider.of<AuthCubit>(context).currentUserModel!.child.profilePicture}", "inviteeAvatar": "${widget.pieceOwner.child.profilePicture}"}',
                    invitees: [
                      ZegoUIKitUser(
                        id: widget.pieceOwner.id,
                        name: widget.pieceOwner.child.name,
                      ),
                    ],
                    onPressed: (code, message, p2) {
                      log("code: $code\nmessage: $message\np2: $p2");
                      getIt<CallService>().onUserEnterCall = (user) {
                        log("user: $user");
                        final currentUser = BlocProvider.of<AuthCubit>(context)
                            .currentUserModel!;
                        FirebaseFirestore.instance
                            .collection(FirebaseConstants.users)
                            .doc(widget.pieceOwner.id)
                            .collection("orders")
                            .doc(currentUser.id)
                            .set({
                          "name": currentUser.child.name,
                          "uId": currentUser.id,
                          "pieceIndex": widget.piece,
                          "level": level,
                        });
                      };
                    },
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
            Positioned(
              bottom: -60,
              right: -20,
              child: isPlaying
                  ? Image.asset(
                      "assets/gif/2.gif",
                      width: 200,
                      height: 200,
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
