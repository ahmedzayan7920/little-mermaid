import 'package:flutter/material.dart';

import '../../../../core/models/user_model.dart';

@immutable
sealed class PieceOwnerState {}

final class PieceOwnerInitialState extends PieceOwnerState {}

final class PieceOwnerLoadingState extends PieceOwnerState {}

final class PieceOwnerSuccessState extends PieceOwnerState {
  final List<UserModel> pieceOwners;

  PieceOwnerSuccessState({required this.pieceOwners});
}

final class PieceOwnerFailureState extends PieceOwnerState {
  final String message;

  PieceOwnerFailureState({required this.message});
}
