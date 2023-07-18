import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/screens/home/home_screen.dart';

import '../../generated/assets.dart';
import '../call/call_pickup_screen.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/audio/");
  bool isPlaying = true;

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
    final url = await player.load("11.mp3");
    audioPlayer.play(UrlSource(url.path));
    audioPlayer.onPlayerComplete.listen((state) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .orderBy("score", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> data = snapshot.data!.docs.toList();
                    if (data.isNotEmpty) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.textColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 30),
                                const Text(
                                  "الفائزين",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.asset(
                                  Assets.assetsWinner,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.fitWidth,
                                ),
                                SizedBox(
                                  height: 235,
                                  width: double.infinity,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 10,
                                        top: 60,
                                        child: SizedBox(
                                          width: 120,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 60,
                                                backgroundColor: AppColors.white,
                                                child: CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider(
                                                      data[1].data()["profilePicture"]),
                                                  radius: 57,
                                                ),
                                              ),
                                              Text(
                                                data[1].data()["name"],
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                data[1].data()["score"].toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 10,
                                        top: 60,
                                        child: SizedBox(
                                          width: 120,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 60,
                                                backgroundColor: AppColors.white,
                                                child: CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider(
                                                      data[2].data()["profilePicture"]),
                                                  radius: 57,
                                                ),
                                              ),
                                              Text(
                                                data[2].data()["name"],
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                data[2].data()["score"].toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: (size.width - 160) / 2,
                                        child: SizedBox(
                                          width: 160,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 80,
                                                backgroundColor: AppColors.white,
                                                child: CircleAvatar(
                                                  backgroundImage: CachedNetworkImageProvider(
                                                      data[0].data()["profilePicture"]),
                                                  radius: 75,
                                                ),
                                              ),
                                              Text(
                                                data[0].data()["name"],
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                data[0].data()["score"].toString(),
                                                textAlign: TextAlign.center,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 50,
                                        top: 30,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Text(
                                            "2",
                                            style: TextStyle(
                                              color: Color(0xFFbbbbbb),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 50,
                                        top: 30,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Text(
                                            "3",
                                            style: TextStyle(
                                              color: Color(0xFFe78c43),
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                              child: ListView.separated(
                                padding: EdgeInsets.zero,
                                itemCount: data.length - 3,
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder: (context, index) => const SizedBox(height: 16),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> child = data[index + 3].data();
                                  return Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                        color: AppColors.textColor, borderRadius: BorderRadius.circular(16)),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 20),
                                        Text(
                                          (index + 4).toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        CircleAvatar(
                                          backgroundImage:
                                              CachedNetworkImageProvider(child["profilePicture"]),
                                          radius: 25,
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Text(
                                            child["name"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Text(
                                          "${child["score"]} pts",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              audioPlayer.stop();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CallPickupScreen(scaffold: HomeScreen()),
                                ),
                                (route) => false,
                              );
                            },
                            child: Container(
                              height: 47,
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 60),
                              decoration: BoxDecoration(
                                color: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitHeight,
                                  child: Text(
                                    "العب مجددا",
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
                          const SizedBox(height: 16),
                        ],
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
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return const Center(
                    child: Text(
                      "حدث خطا برجاء المحاولة لاحقا",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }),
            isPlaying?Image.asset(
              "assets/gif/11.gif",
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ):const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
