import 'question_model.dart';

class QuestionnaireAnswersModel {
  final Map<String, bool> answers;
  final bool? firstAnswer;
  final num totalScore;
  final bool isCompleted;
  final bool isSaving;

  QuestionnaireAnswersModel({
    required this.answers,
    this.firstAnswer,
    this.totalScore = 0,
    this.isCompleted = false,
    this.isSaving = false,
  });

  QuestionnaireAnswersModel copyWith({
    Map<String, bool>? answers,
    bool? firstAnswer,
    num? totalScore,
    bool? isCompleted,
    bool? isSaving,
  }) {
    return QuestionnaireAnswersModel(
      answers: answers ?? this.answers,
      firstAnswer: firstAnswer ?? this.firstAnswer,
      totalScore: totalScore ?? this.totalScore,
      isCompleted: isCompleted ?? this.isCompleted,
      isSaving: isSaving ?? this.isSaving,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'answers': answers,
      'firstAnswer': firstAnswer,
      'totalScore': totalScore,
      'isCompleted': isCompleted,
    };
  }

  factory QuestionnaireAnswersModel.fromJson(Map<String, dynamic> map) {
    try {
      return QuestionnaireAnswersModel(
        answers: Map<String, bool>.from((map['answers'] ?? {})),
        firstAnswer: map['firstAnswer'],
        totalScore: map['totalScore'] ?? 0,
        isCompleted: map['isCompleted'] ?? false,
      );
    } catch (e) {
      throw Exception('Error parsing QuestionnaireAnswersModel from JSON: $e');
    }
  }

  num calculateScore(List<QuestionModel> questions) {
    if (firstAnswer == null) return 0;

    int startIndex = firstAnswer! ? 1 : 7;
    num score = 0;

    for (var question in questions) {
      if (int.parse(question.id) >= startIndex && answers.containsKey(question.id)) {
        if (answers[question.id] == question.correctAnswer) {
          score += question.scoreValue;
        }
      }
    }
    return score;
  }

  double calculateProgress() {
    if (answers.isEmpty) return 0.0;

    if (firstAnswer == false) {
      int answeredAfterEight =
          answers.keys.where((id) => int.parse(id) >= 8).length + 1;
      return answeredAfterEight / 34.0;
    } else {
      return answers.length / 40;
    }
  }
}
