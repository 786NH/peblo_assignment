import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quiz_model.dart';
import '../services/quiz_service.dart';
import 'quiz_state.dart';

final quizServiceProvider =
    Provider<QuizService>(
  (ref) => QuizService(),
);

class QuizNotifier
    extends StateNotifier<QuizState> {
  QuizNotifier(
    this._service,
  ) : super(QuizState.initial());

  final QuizService _service;

  Future<void> loadQuiz() async {
    try {
      state = state.copyWith(
        isLoading: true,
      );

      final response =
          await _service.fetchQuiz();

      state = state.copyWith(
        isLoading: false,
        story: response.story,
        questions: response.questions,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }

  QuizModel? get currentQuestion =>
      state.currentQuestion;

  void nextQuestion() {
    if (state.hasNextQuestion) {
      state = state.copyWith(
        currentQuestionIndex:
            state.currentQuestionIndex +
            1,
      );
    }
  }

  bool isLastQuestion() {
    return !state.hasNextQuestion;
  }
}

final quizProvider =
    StateNotifierProvider<
      QuizNotifier,
      QuizState
    >(
      (ref) => QuizNotifier(
        ref.read(
          quizServiceProvider,
        ),
      ),
    );