import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/di/di.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/features/piece/ui/views/profile_owner_screen.dart';

import '../../logic/cubit/piece_owner_cubit.dart';
import '../../logic/cubit/piece_owner_state.dart';

class PieceOwnerScreen extends StatefulWidget {
  final int piece;

  const PieceOwnerScreen({
    super.key,
    required this.piece,
  });

  @override
  State<PieceOwnerScreen> createState() => _PieceOwnerScreenState();
}

class _PieceOwnerScreenState extends State<PieceOwnerScreen> {
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
    final url = await player.load("5.mp3");
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
    return BlocProvider(
      create: (context) => PieceOwnerCubit(userRepository: getIt())
        ..getPieceOwners(
          level: level,
          piece: widget.piece,
        ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              const CustomBackground(),
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
                    Expanded(
                      child: BlocBuilder<PieceOwnerCubit, PieceOwnerState>(
                        builder: (context, state) {
                          if (state is PieceOwnerSuccessState) {
                            if (state.pieceOwners.isNotEmpty) {
                              return ListView.separated(
                                itemCount: state.pieceOwners.length,
                                separatorBuilder: (_, i) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final child = state.pieceOwners[index];
                                  return InkWell(
                                    onTap: () {
                                      audioPlayer.stop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileOwnerScreen(
                                            piece: widget.piece,
                                            pieceOwner: child,
                                          ),
                                        ),
                                      ).then(
                                        (value) => setAudio(),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        border: Border.all(
                                          color: AppColors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(
                                                  child.child.profilePicture),
                                          radius: 25,
                                        ),
                                        title: Text(
                                          child.child.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
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
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: AppColors.white,
                                  ),
                                ),
                              );
                            }
                          } else if (state is PieceOwnerFailureState) {
                            return Center(
                              child: Text(
                                state.message,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 30,
                                  color: AppColors.white,
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
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
              Positioned(
                bottom: 0,
                child: isPlaying
                    ? RotationTransition(
                        turns: const AlwaysStoppedAnimation(.25),
                        child: Image.asset(
                          "assets/gif/2.gif",
                          width: 250,
                          height: 250,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
