import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/home/home_screen.dart';

import '../../../../core/di/di.dart';
import '../../logic/selection/selection_cubit.dart';
import '../../logic/selection/selection_state.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  int selectedIndex = -1;

  int count = 0;

  List images = [0, 1, 2];

  Map<String, int> selection = {
    "1": 0,
    "2": 0,
    "3": 0,
  };

  final audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/audio/");
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    setAudio("${count + 1}.mp3");
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    player.clearAll();
    super.dispose();
  }

  Future setAudio(String fileName) async {
    final url = await player.load(fileName);
    audioPlayer.play(UrlSource(url.path));
    audioPlayer.onPlayerComplete.listen((state) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectionCubit(
        userRepository: getIt(),
        authCubit: context.read<AuthCubit>(),
      ),
      child: BlocListener<SelectionCubit, SelectionState>(
        listener: (context, state) {
          if (state is SelectionSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    const HomeScreen(),
              ),
              (route) => false,
            );
          } else if (state is SelectionFailureState) {
            Navigator.pop(context);
            showAwesomeDialog(context, state.message);
          } else if (state is SelectionLoadingState) {
            showLoadingDialog(context);
          }
        },
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
                      Image.asset(Assets.assetsLogo, width: 120, height: 100),
                      const SizedBox(height: 24),
                      const Spacer(),
                      Container(
                        width: 205,
                        height: 205,
                        color: selectedIndex == 0
                            ? Colors.red
                            : Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            color: Colors.white,
                            child: Image.asset(
                              "assets/selection_${images[0]}.jpeg",
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 205,
                        height: 205,
                        color: selectedIndex == 1
                            ? Colors.red
                            : Colors.transparent,
                        padding: const EdgeInsets.all(5),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });
                          },
                          child: Container(
                            width: 200,
                            height: 200,
                            color: Colors.white,
                            child: Image.asset(
                              "assets/selection_${images[1]}.jpeg",
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      const Spacer(),
                      BlocBuilder<SelectionCubit, SelectionState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: selectedIndex == -1
                                ? null
                                : () {
                                    int value = selection[
                                            (images[selectedIndex] + 1)
                                                .toString()] ??
                                        0;
                                    selection[(images[selectedIndex] + 1)
                                        .toString()] = value + 1;
                                    if (count >= 5) {
                                      BlocProvider.of<SelectionCubit>(context)
                                          .updateSelection(
                                              selection: selection);
                                    } else {
                                      if (selectedIndex == 0) {
                                        int temp = images[2];
                                        images[2] = images[1];
                                        images[1] = temp;
                                      } else {
                                        int temp = images[2];
                                        images[2] = images[0];
                                        images[0] = temp;
                                      }
                                      selectedIndex = -1;
                                      count++;
                                      setState(() {});
                                      setAudio("${(count % 3) + 1}.mp3");
                                    }
                                  },
                            child: Container(
                              height: 47,
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 70),
                              decoration: BoxDecoration(
                                color: selectedIndex == -1
                                    ? Colors.grey
                                    : AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Row(
                                    children: [
                                      Text(
                                        count < 5 ? "التالي" : "إنهاء",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: isPlaying
                      ? Image.asset(
                          "assets/gif/1.gif",
                          width: 250,
                          height: 250,
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
