import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/core/repos/user_repository.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';

import 'selection_state.dart';

class SelectionCubit extends Cubit<SelectionState> {
  SelectionCubit({
    required UserRepository userRepository,
    required AuthCubit authCubit,
  })  : _userRepository = userRepository,
        _authCubit = authCubit,
        super(SelectionInitialState());

  final UserRepository _userRepository;
  final AuthCubit _authCubit;

  updateSelection({required Map<String, int> selection}) async {
    emit(SelectionLoadingState());
    final userModel = _authCubit.currentUserModel!;
    final updatedUser = userModel.copyWith(
      selection: selection,
    );
    final result = await _userRepository.updateUserModel(userModel: updatedUser);
    result.fold(
      (failure) => emit(SelectionFailureState(failure.message)),
      (userModel) {
        _authCubit.syncUserData(updatedUserModel: userModel);
        emit(SelectionSuccessState());
      },
    );
  }
}
