import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/repos/user_repository.dart';
import 'piece_owner_state.dart';

class PieceOwnerCubit extends Cubit<PieceOwnerState> {
  PieceOwnerCubit({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(PieceOwnerInitialState());
  final UserRepository _userRepository;

  void getPieceOwners({
    required int level,
    required int piece,
  }) async {
    emit(PieceOwnerLoadingState());
    final result =
        await _userRepository.getPieceOwnerUsers(level: level, piece: piece);
    result.fold(
      (failure) => emit(PieceOwnerFailureState(message: failure.message)),
      (pieceOwners) => emit(PieceOwnerSuccessState(pieceOwners: pieceOwners)),
    );
  }
}
