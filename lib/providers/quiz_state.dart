import '../models/quiz_model.dart';

class QuizState {
  final bool isLoading;
  final String story;
  final List<QuizModel> questions;
  final int currentQuestionIndex;

  const QuizState({
    required this.isLoading,
    required this.story,
    required this.questions,
    required this.currentQuestionIndex,
  });

  factory QuizState.initial() {
    return const QuizState(
      isLoading: false,
      story: '',
      questions: [],
      currentQuestionIndex: 0,
    );
  }

  QuizModel? get currentQuestion {
    if (questions.isEmpty) return null;

    return questions[currentQuestionIndex];
  }

  bool get hasNextQuestion {
    return currentQuestionIndex <
        questions.length - 1;
  }

  QuizState copyWith({
    bool? isLoading,
    String? story,
    List<QuizModel>? questions,
    int? currentQuestionIndex,
  }) {
    return QuizState(
      isLoading:
          isLoading ?? this.isLoading,
      story: story ?? this.story,
      questions:
          questions ?? this.questions,
      currentQuestionIndex:
          currentQuestionIndex ??
          this.currentQuestionIndex,
    );
  }
}