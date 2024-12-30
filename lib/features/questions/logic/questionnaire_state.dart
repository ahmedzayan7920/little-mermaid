import '../models/questionnaire_answers_model.dart';

abstract class QuestionnaireState {
  final QuestionnaireAnswersModel answersModel;
  
  const QuestionnaireState({required this.answersModel});
}

// The main state for handling questions and answers
class QuestionnaireAnsweringState extends QuestionnaireState {
  const QuestionnaireAnsweringState({required super.answersModel});
}

// State when uploading to Firebase
class QuestionnaireUploadingState extends QuestionnaireState {
  const QuestionnaireUploadingState({required super.answersModel});
}

// State for upload failures
class QuestionnaireUploadFailureState extends QuestionnaireState {
  final String message;

  const QuestionnaireUploadFailureState({
    required super.answersModel,
    required this.message,
  });
}

// State for successful upload
class QuestionnaireUploadSuccessState extends QuestionnaireState {
  const QuestionnaireUploadSuccessState({required super.answersModel});
}