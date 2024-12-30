import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/core/repos/storage_repository.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../core/models/user_model.dart';
import '../../../core/repos/user_repository.dart';
import '../repos/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;

  AuthCubit({
    required AuthRepository authRepository,
    required UserRepository userRepository,
    required StorageRepository storageRepository,
  })  : _authRepository = authRepository,
        _userRepository = userRepository,
        _storageRepository = storageRepository,
        super(const AuthInitialState());

  UserModel? get currentUserModel {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      return currentState.userModel;
    }
    return null;
  }

  void syncUserData({required UserModel updatedUserModel}) {
    final currentState = state;
    if (currentState is AuthenticatedState) {
      emit(AuthenticatedState(userModel: updatedUserModel));
    }
  }

  Future<void> checkAuthStatus() async {
    emit(const AuthLoadingState());

    final result = _userRepository.getLocalCurrentUserModel();
    result.fold(
      (failure) => emit(const UnauthenticatedState()),
      (userModel) => emit(AuthenticatedState(userModel: userModel)),
    );
  }

  Future<void> register({
    required UserModel userModel,
    required String password,
    required String imagePath,
  }) async {
    emit(const AuthLoadingState());
    final isSSNFound =
        await _userRepository.isSSNFound(ssn: userModel.child.ssn);
    if (isSSNFound) {
      emit(AuthErrorState(message: "الرقم القومي للطفل موجود بالفعل"));
    } else {
      final registerResult = await _authRepository.register(
        email: userModel.email,
        password: password,
      );
      registerResult.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (user) async {
          final uploadUserImageResult = await _storageRepository.uploadFile(
            refPath: "profilePic/${user.uid}",
            imagePath: imagePath,
          );
          uploadUserImageResult.fold(
            (failure) => emit(AuthErrorState(message: failure.message)),
            (downloadUrl) async {
              final newUser = userModel.copyWith(
                id: user.uid,
                child: userModel.child.copyWith(
                  profilePicture: downloadUrl,
                ),
              );
              final saveUserModelResult =
                  await _userRepository.saveUserModel(userModel: newUser);
              saveUserModelResult.fold(
                (failure) => emit(AuthErrorState(message: failure.message)),
                (userModel) => emit(AuthenticatedState(userModel: userModel)),
              );
            },
          );
        },
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoadingState());

    final result = await _authRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) async {
        final fetchUserResult =
            await _userRepository.getRemoteCurrentUserModel(userId: user.uid);
        fetchUserResult.fold(
          (failure) => emit(AuthErrorState(message: failure.message)),
          (userModel) => emit(AuthenticatedState(userModel: userModel)),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(const AuthLoadingState());

    final result = await _authRepository.logout();

    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) {
        ZegoUIKitPrebuiltCallInvitationService().uninit();
        _userRepository.deleteLocalUserModel();
        emit(const UnauthenticatedState());
      },
    );
  }
}
