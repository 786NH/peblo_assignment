import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum StoryState {
  idle,
  loading,
  speaking,
  quizVisible,
  success,
  error,
}

class StoryNotifier extends StateNotifier<StoryState> {
  StoryNotifier() : super(StoryState.idle);

  bool buddyHappy = false;

  final ConfettiController confettiController =
      ConfettiController(
    duration: const Duration(seconds: 2),
  );

  void setLoading() {
    state = StoryState.loading;
  }

  void setSpeaking() {
    state = StoryState.speaking;
  }

  void showQuiz() {
    state = StoryState.quizVisible;
  }

  void showError() {
    state = StoryState.error;
  }

  void success() {
    buddyHappy = true;
    confettiController.play();
    state = StoryState.success;
  }
}

final storyProvider =
    StateNotifierProvider<StoryNotifier, StoryState>(
  (ref) => StoryNotifier(),
);