import 'package:agora_uikit/agora_uikit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:puzzle/core/agora_config.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/models/call_model.dart';
import 'package:puzzle/screens/home/home_screen.dart';

class CallScreen extends StatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  const CallScreen({
    Key? key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  AgoraClient? client;
  String baseUrl = "https://whatsapp-clone-server-lwsj.onrender.com";

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
      agoraEventHandlers: AgoraRtcEventHandlers(
        onUserOffline: (connection, remoteUid, reason) async {
          await client!.engine.leaveChannel();
          endCall(
            context: context,
            callerId: widget.call.callerId,
            receiverId: widget.call.receiverId,
          );
        },
        onLeaveChannel: (connection, stats) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        },
      ),
    );
    initAgora();
    setAudio();
  }

  final audioPlayer = AudioPlayer();
  final player = AudioCache(prefix: "assets/audio/");


  @override
  void dispose() {
    audioPlayer.dispose();
    player.clearAll();
    super.dispose();
  }

  Future setAudio() async {
    final url = await player.load("7.mp3");
    audioPlayer.play(UrlSource(url.path));
  }

  initAgora() async {
    await client!.initialize();
  }

  void endCall({
    required BuildContext context,
    required String callerId,
    required String receiverId,
  }) async {
    try {
      await FirebaseFirestore.instance.collection("calls").doc(callerId).delete();
      await FirebaseFirestore.instance.collection("calls").doc(receiverId).delete();
      if (mounted){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
          (route) => false,
        );
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: client == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        onPressed: () async {
                          await client!.engine.leaveChannel();
                          endCall(
                            context: context,
                            callerId: widget.call.callerId,
                            receiverId: widget.call.receiverId,
                          );
                        },
                        icon: const Icon(
                          Icons.call_end_outlined,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
