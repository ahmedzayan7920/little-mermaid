import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/call/call_pickup_screen.dart';
import 'package:puzzle/screens/auth/login_screen.dart';
import 'package:puzzle/screens/home/orders_screen.dart';
import 'package:puzzle/screens/home/piece_owner_screen.dart';
import 'package:puzzle/screens/home/winner_screen.dart';

import '../../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String name;
  late String profilePicture;
  late List pieces;
  int colorIndex = 0;
  final ref = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

  final audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/audio/");

  @override
  void initState() {
    super.initState();
    setAudio();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    player.clearAll();
    super.dispose();
  }

  Future setAudio() async {
    final url = await player.load("4.mp3");
    audioPlayer.play(UrlSource(url.path));
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width - 120;
    Size size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CallPickupScreen(
        scaffold: Scaffold(
          body: Stack(
            children: [
              const CustomBackground(),
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
                                SizedBox(
                                  height: size.height / 13,
                                  child: FittedBox(
                                    fit: BoxFit.fitHeight,
                                    child: Text(
                                      "ملفي الشخصي",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 15),
                                height: double.infinity,
                                child: Stack(
                                  children: [
                                    LayoutBuilder(builder: (context, constraints) {
                                      return Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          height: constraints.maxHeight - size.height / 9,
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
                                        padding: const EdgeInsets.only(bottom: 10, left: 35, right: 35),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: size.height / 9,
                                              backgroundColor: AppColors.white,
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(user!["profilePicture"]),
                                                radius: size.height / 9.7,
                                              ),
                                            ),
                                            Text(
                                              user["name"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: AppColors.textColor,
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Divider(
                                              height: 0,
                                              thickness: 2,
                                              color: AppColors.primary,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.ltr,
                                              child: Expanded(
                                                child: GridView.builder(
                                                  itemCount: 4,
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    mainAxisSpacing: 3,
                                                    crossAxisSpacing: 3,
                                                    childAspectRatio: 1 / 1,
                                                  ),
                                                  itemBuilder: (BuildContext context, int index) {
                                                    if (user["pieces"].contains(index)) {
                                                      Map selection = user["selection"];
                                                      Map data = Map.fromEntries(
                                                        selection.entries.toList()
                                                          ..sort(
                                                            (a, b) => a.value.compareTo(b.value),
                                                          ),
                                                      );
                                                      // print(selection);
                                                      List noSort = [0];
                                                      for (int i = 0; i < data.keys.toList().length; i++) {
                                                        noSort.add(int.parse(data.keys.toList()[i]));
                                                      }
                                                      return Stack(
                                                        children: [
                                                          Image.asset(
                                                            "assets/${noSort[user["level"] % 4]}$index.jpeg",
                                                            fit: BoxFit.fill,
                                                            width: double.infinity,
                                                            height: double.infinity,
                                                          ),
                                                          Align(
                                                            alignment: index == 0
                                                                ? AlignmentDirectional.topStart
                                                                : index == 1
                                                                    ? AlignmentDirectional.topEnd
                                                                    : index == 2
                                                                        ? AlignmentDirectional.bottomStart
                                                                        : AlignmentDirectional.bottomEnd,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(8),
                                                              color: Colors.grey,
                                                              child: Text(
                                                                "${index + 1}",
                                                                style: TextStyle(
                                                                  fontSize: 24,
                                                                  color: AppColors.white,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      Color color = Colors.red;
                                                      if (colorIndex % 3 == 0) {
                                                        color = Colors.red;
                                                      } else if (colorIndex % 3 == 1) {
                                                        color = Colors.green;
                                                      } else if (colorIndex % 3 == 2) {
                                                        color = Colors.blue;
                                                      }
                                                      colorIndex++;
                                                      return InkWell(
                                                        onTap: () async {
                                                          audioPlayer.stop();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) => PieceOwnerScreen(
                                                                  pieceIndex: index, level: user["level"]),
                                                            ),
                                                          ).then(
                                                            (value) => setAudio(),
                                                          );
                                                        },
                                                        child: Stack(
                                                          children: [
                                                            Container(
                                                              color: color,
                                                              width: double.infinity,
                                                              height: double.infinity,
                                                            ),
                                                            Align(
                                                              alignment: index == 0
                                                                  ? AlignmentDirectional.topStart
                                                                  : index == 1
                                                                      ? AlignmentDirectional.topEnd
                                                                      : index == 2
                                                                          ? AlignmentDirectional.bottomStart
                                                                          : AlignmentDirectional.bottomEnd,
                                                              child: Container(
                                                                padding: const EdgeInsets.all(8),
                                                                color: Colors.grey,
                                                                child: Text(
                                                                  "${index + 1}",
                                                                  style: TextStyle(
                                                                    fontSize: 24,
                                                                    color: AppColors.white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
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
                                          audioPlayer.stop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WinnerScreen(
                                                userPiece: user["userPiece"],
                                                level: user["level"],
                                                name: user["name"],
                                                profilePicture: user["profilePicture"],
                                              ),
                                            ),
                                          ).then(
                                                (value) => setAudio(),
                                          );
                                        },
                                        child: Container(
                                          height: 47,
                                          width: (buttonWidth / 2) - 3,
                                          decoration: BoxDecoration(
                                            color: AppColors.buttonColor,
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(30),
                                              bottomRight: Radius.circular(30),
                                            ),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "انهاء اللعبة",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                          audioPlayer.stop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => OrdersScreen(level: user["level"]),
                                            ),
                                          ).then(
                                                (value) => setAudio(),
                                          );
                                        },
                                        child: Container(
                                          height: 47,
                                          width: (buttonWidth / 2) - 3,
                                          decoration: BoxDecoration(
                                            color: AppColors.buttonColor,
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30),
                                            ),
                                          ),
                                          child: Center(
                                            child: FittedBox(
                                              fit: BoxFit.fitHeight,
                                              child: Text(
                                                "الطلبات",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                      audioPlayer.stop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => OrdersScreen(level: user["level"]),
                                        ),
                                      ).then(
                                            (value) => setAudio(),
                                      );
                                    },
                                    child: Container(
                                      height: 47,
                                      width: buttonWidth,
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonColor,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                        child: FittedBox(
                                          fit: BoxFit.fitHeight,
                                          child: Text(
                                            "الطلبات",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                      sharedPreferences.remove("id").then((value) {
                        FirebaseAuth.instance.signOut().then((value) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        });
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
