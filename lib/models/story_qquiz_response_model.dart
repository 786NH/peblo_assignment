import 'quiz_model.dart';

class StoryQuizResponse {
  final String story;
  final List<QuizModel> questions;

  StoryQuizResponse({
    required this.story,
    required this.questions,
  });

  factory StoryQuizResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return StoryQuizResponse(
      story: json['story'],
      questions:
          (json['questions'] as List)
              .map(
                (e) => QuizModel.fromJson(e),
              )
              .toList(),
    );
  }
}