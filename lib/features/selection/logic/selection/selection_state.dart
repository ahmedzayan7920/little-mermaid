import 'package:flutter/material.dart';

@immutable
sealed class SelectionState {}

final class SelectionInitialState extends SelectionState {}
final class SelectionLoadingState extends SelectionState {}
final class SelectionSuccessState extends SelectionState {}
final class SelectionFailureState extends SelectionState {
  final String message;

  SelectionFailureState(this.message);
}
