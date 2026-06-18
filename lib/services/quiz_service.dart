import 'dart:convert';

import 'package:peblo_assignment/models/story_qquiz_response_model.dart';

class QuizService {
  Future<StoryQuizResponse> fetchQuiz() async {
    await Future.delayed(const Duration(seconds: 1));

    // for demo purpose
    final response = jsonDecode('''
{
  "story": "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...",
  "questions": [
    {
      "id": 1,
      "question": "What colour was Pip's gear?",
      "options": ["Red", "Green", "Blue", "Yellow"],
      "answer": "Blue"
    },
    {
      "id": 2,
      "question": "What was the robot's name?",
      "options": ["Pip", "Max", "Tom", "Robo"],
      "answer": "Pip"
    }
  ]
}
''');



    return StoryQuizResponse.fromJson(response);
  }
}
