import '../../../core/models/user_model.dart';

sealed class AuthState {
  const AuthState();
}

class AuthInitialState extends AuthState {
  const AuthInitialState();
}

class AuthenticatedState extends AuthState {
  final UserModel userModel;

  const AuthenticatedState({required this.userModel});
}

class UnauthenticatedState extends AuthState {
  const UnauthenticatedState();
}

class AuthLoadingState extends AuthState {
  const AuthLoadingState();
}

class AuthErrorState extends AuthState {
  final String message;

  const AuthErrorState({required this.message});
}
