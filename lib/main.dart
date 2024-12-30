import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/app_theme.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'core/di/di.dart';
import 'features/auth/logic/auth_state.dart';
import 'features/auth/ui/views/login_screen.dart';
import 'features/questions/ui/views/questionnaire_view.dart';
import 'features/selection/ui/views/selection_screen.dart';
import 'screens/home/home_screen.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupDependencyInjection();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );
    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: getIt(),
        storageRepository: getIt(),
        userRepository: getIt(),
      )..checkAuthStatus(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme,
        navigatorObservers: [routeObserver],
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthenticatedState) {
              if (state.userModel.questionnaireAnswersModel.isCompleted) {
                final defaultSelections = {
                  "0": 0,
                  "1": 0,
                  "2": 0,
                };

                if (mapEquals(state.userModel.selection, defaultSelections)) {
                  return SelectionScreen();
                } else {
                  return HomeScreen();
                }
              } else {
                return QuestionnaireView();
              }
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
