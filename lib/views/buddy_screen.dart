import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peblo_assignment/providers/quiz_service_provider.dart.dart';
import '../providers/story_provider.dart';
import '../services/tts_service.dart';
import '../widgets/buddy_widget.dart';
import '../widgets/quiz_card.dart';
import '../widgets/story_card.dart';

class StoryBuddyScreen extends ConsumerStatefulWidget {
  const StoryBuddyScreen({super.key});

  @override
  ConsumerState<StoryBuddyScreen> createState() =>
      _StoryBuddyScreenState();
}

class _StoryBuddyScreenState
    extends ConsumerState<StoryBuddyScreen> {
  final TtsService _ttsService = TtsService();

  String? selectedOption;
  bool isCorrectAnswer = false;
  bool showQuiz = false;

  @override
  void initState() {
    super.initState();

    _ttsService.init();

    Future.microtask(() {
      ref.read(quizProvider.notifier).loadQuiz();
    });
  }

  Future<void> playStory() async {
    final storyNotifier =
        ref.read(storyProvider.notifier);

    final quizState = ref.read(quizProvider);

    try {
      storyNotifier.setLoading();

      await Future.delayed(
        const Duration(milliseconds: 800),
      );

      storyNotifier.setSpeaking();

      await _ttsService.speak(
        quizState.story,
        () {
          storyNotifier.showQuiz();

          if (mounted) {
            setState(() {
              showQuiz = true;
            });
          }
        },
      );
    } catch (e) {
      storyNotifier.showError();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Unable to play story.',
            ),
          ),
        );
      }
    }
  }

  void checkAnswer(String answer) {
    final quizState = ref.read(quizProvider);

    final currentQuestion =
        quizState.currentQuestion;

    if (currentQuestion == null) return;

    setState(() {
      selectedOption = answer;
      isCorrectAnswer =
          answer == currentQuestion.answer;
    });

    final storyNotifier =
        ref.read(storyProvider.notifier);

    if (answer == currentQuestion.answer) {
      storyNotifier.success();

      Future.delayed(
        const Duration(seconds: 2),
        () {
          if (!mounted) return;

          final quizNotifier =
              ref.read(
                quizProvider.notifier,
              );

          if (quizNotifier.isLastQuestion()) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) => AlertDialog(
                    title: const Text(
                      '🎉 Great Job!',
                    ),
                    content: const Text(
                      'You completed all questions.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        child: const Text(
                          'OK',
                        ),
                      ),
                    ],
                  ),
            );
          } else {
            quizNotifier.nextQuestion();

            setState(() {
              selectedOption = null;
              isCorrectAnswer = false;
            });
          }
        },
      );
    } else {
      HapticFeedback.mediumImpact();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Oops! Try again 😊',
          ),
        ),
      );

      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          if (!mounted) return;

          setState(() {
            selectedOption = null;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final storyState =
        ref.watch(storyProvider);

    final storyNotifier =
        ref.read(storyProvider.notifier);

    final quizState =
        ref.watch(quizProvider);

    final currentQuestion =
        quizState.currentQuestion;

    if (quizState.isLoading) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(
        0xffF8F8FC,
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'AI Story Buddy',
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              children: [
                BuddyWidget(
                  happy:
                      storyNotifier.buddyHappy,
                ),

                const SizedBox(
                  height: 20,
                ),

                StoryCard(
                  story: quizState.story,
                ),

                const SizedBox(
                  height: 30,
                ),

                AnimatedSwitcher(
                  duration:
                      const Duration(
                        milliseconds: 300,
                      ),
                  child:
                      storyState ==
                              StoryState.idle
                          ? _buildStoryButton()
                          : storyState ==
                                      StoryState
                                          .loading ||
                                  storyState ==
                                      StoryState
                                          .speaking
                              ? _buildLoader(
                                storyState,
                              )
                              : const SizedBox
                                  .shrink(),
                ),

                const SizedBox(
                  height: 30,
                ),

                if (showQuiz &&
                    currentQuestion !=
                        null)
                  QuizCard(
                        quiz:
                            currentQuestion,
                        selectedOption:
                            selectedOption,
                        isCorrectAnswer:
                            isCorrectAnswer,
                        onOptionSelected:
                            checkAnswer,
                      )
                      .animate()
                      .fade()
                      .scale(),
              ],
            ),
          ),

          Align(
            alignment:
                Alignment.topCenter,
            child: ConfettiWidget(
              confettiController:
                  storyNotifier
                      .confettiController,
              blastDirectionality:
                  BlastDirectionality
                      .explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryButton() {
    return Container(
      key: const ValueKey(
        'story_button',
      ),
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF7B2FE4),
            Color(0xFF6F2BC2),
          ],
        ),
        borderRadius:
            BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xFF6F2BC2,
            ).withOpacity(.3),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius:
              BorderRadius.circular(30),
          onTap: playStory,
          child: const Center(
            child: Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  Icons.volume_up_rounded,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  'Read Me A Story',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoader(
    StoryState state,
  ) {
    return Container(
      key: const ValueKey('loader'),
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
            vertical: 20,
          ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color:
              Colors.deepPurple.shade100,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 40,
            height: 40,
            child:
                CircularProgressIndicator(),
          ),
          const SizedBox(height: 12),
          Text(
            state ==
                    StoryState.loading
                ? 'Pip is preparing your story...'
                : 'Pip is telling the story...',
            style: const TextStyle(
              fontSize: 16,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}