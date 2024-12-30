import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/core/repos/user_repository.dart';
import 'package:puzzle/features/auth/logic/auth_cubit.dart';

import '../models/question_model.dart';
import '../models/questionnaire_answers_model.dart';
import 'questionnaire_state.dart';

class QuestionnaireCubit extends Cubit<QuestionnaireState> {
  final List<QuestionModel> questions;
  final UserRepository _userRepository;
  final AuthCubit _authCubit;

  QuestionnaireCubit({
    required this.questions,
    required UserRepository userRepository,
    required AuthCubit authCubit,
  })  : _userRepository = userRepository,
        _authCubit = authCubit,
        // Initialize with an empty answering state
        super(QuestionnaireAnsweringState(
          answersModel: QuestionnaireAnswersModel(answers: {}),
        ));

  void answerQuestion(String questionId, bool answer) {
    // Get the current answers model
    final currentModel = state.answersModel;
    
    // Create updated answers map
    final updatedAnswers = Map<String, bool>.from(currentModel.answers);
    updatedAnswers[questionId] = answer;

    // Create updated model with new answer
    final updatedModel = currentModel.copyWith(
      answers: updatedAnswers,
      // Set firstAnswer if this is question 1
      firstAnswer: int.parse(questionId) == 1 ? answer : currentModel.firstAnswer,
    );

    // Calculate the new score
    final newScore = updatedModel.calculateScore(questions);
    final finalModel = updatedModel.copyWith(totalScore: newScore);

    // If this is the last question, start the upload process
    if (int.parse(questionId) == 40) {
      final uploadModel = finalModel.copyWith(
        isCompleted: true,
        isSaving: true,
      );
      emit(QuestionnaireUploadingState(answersModel: uploadModel));
      _saveToFirestore(uploadModel);
    } else {
      // Otherwise, just update the answering state
      emit(QuestionnaireAnsweringState(answersModel: finalModel));
    }
  }

  Future<void> _saveToFirestore(QuestionnaireAnswersModel model) async {
    try {
      final userModel = _authCubit.currentUserModel!;
      final updatedUser = userModel.copyWith(
        questionnaireAnswersModel: model,
      );
      
      final result = await _userRepository.updateUserModel(
        userModel: updatedUser,
      );
      
      result.fold(
        (failure) {
          // On failure, emit failure state with the current model
          emit(QuestionnaireUploadFailureState(
            answersModel: model.copyWith(isSaving: false),
            message: failure.toString(),
          ));
        },
        (userModel) {
          // On success, sync user data and emit success state
          _authCubit.syncUserData(updatedUserModel: userModel);
          emit(QuestionnaireUploadSuccessState(
            answersModel: model.copyWith(
              isSaving: false,
              isCompleted: true,
            ),
          ));
        },
      );
    } catch (e) {
      emit(QuestionnaireUploadFailureState(
        answersModel: model.copyWith(isSaving: false),
        message: e.toString(),
      ));
    }
  }

  String get currentQuestionId {
    final currentState = state.answersModel;
    
    if (currentState.answers.isEmpty) return '1';

    if (currentState.firstAnswer == false) {
      if (currentState.answers.length == 1) return '8';

      String lastAnsweredQuestion = currentState.answers.keys.reduce(
        (max, current) => int.parse(max) > int.parse(current) ? max : current
      );
      return int.parse(lastAnsweredQuestion) >= 40
          ? '40'
          : (int.parse(lastAnsweredQuestion) + 1).toString();
    } else {
      int nextQuestion = currentState.answers.length + 1;
      return nextQuestion > 40 ? '40' : nextQuestion.toString();
    }
  }

  QuestionModel getCurrentQuestion() {
    return questions.firstWhere(
      (q) => q.id == currentQuestionId,
      orElse: () => questions.last,
    );
  }

  double getProgress() {
    return state.answersModel.calculateProgress();
  }
}