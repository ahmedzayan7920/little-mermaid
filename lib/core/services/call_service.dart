import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../generated/assets.dart';
import '../../screens/home/home_screen.dart';
import '../models/user_model.dart';

class CallService {
  Function(ZegoUIKitUser)? onUserEnterCall;

  void init(BuildContext context, UserModel userModel) {
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 0,
      appSign:
          '',
      userID: userModel.id,
      userName: userModel.child.name,
      notificationConfig: ZegoCallInvitationNotificationConfig(
        androidNotificationConfig: ZegoCallAndroidNotificationConfig(
          showFullScreen: true,
          fullScreenBackgroundAssetURL: 'assets/call.png',
          callChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "ZegoUIKit",
            channelName: "Call Notifications",
            sound: "call",
            icon: "call",
          ),
          missedCallChannel: ZegoCallAndroidNotificationChannelConfig(
            channelID: "MissedCall",
            channelName: "Missed Call",
            sound: "missed_call",
            icon: "missed_call",
            vibrate: false,
          ),
        ),
        iOSNotificationConfig: ZegoCallIOSNotificationConfig(
          systemCallingIconName: 'CallKitIcon',
        ),
      ),
      plugins: [ZegoUIKitSignalingPlugin()],
      // uiConfig: ZegoCallInvitationUIConfig(
      //   invitee: ZegoCallInvitationInviteeUIConfig(
      //     // showAvatar: false,
      //   ),
      //   inviter: ZegoCallInvitationInviterUIConfig(
      //     // showAvatar: false,
      //   ),
      // ),
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) {
          defaultAction();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
            (route) => false,
          );
        },
        user: ZegoCallUserEvents(
          onEnter: (user) {
            if (onUserEnterCall != null) {
              onUserEnterCall!(user);
              onUserEnterCall = null;
            }
          },
          onLeave: (user) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
              (route) => false,
            );
          },
        ),
      ),
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
                : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallInvitationType.videoCall == data.type
                ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config.avatarBuilder = (
          BuildContext context,
          Size size,
          ZegoUIKitUser? user,
          Map extraInfo,
        ) {
          return CircleAvatar(
            radius: 70,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Assets.assetsLogo, fit: BoxFit.contain),
            ),
          );
        };

        return config;
      },
    );
  }
}
