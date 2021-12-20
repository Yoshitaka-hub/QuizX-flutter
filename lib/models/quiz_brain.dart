import 'question.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math' as math;

class QuizBrain {
  int _questionNumber = 0;
  List<Question> _quizData = []; //データ

  void loadQuizData(List<Map<String, dynamic>> dataList) {
    _quizData = dataList
        .map((Map<String, dynamic> data) => Question.fromJson(data))
        .toList();
  }

  void nextQuestion() {
    if (_questionNumber != 0) {
      _quizData.removeAt(_questionNumber);
    }
    if (_quizData.isNotEmpty) {
      var rand = math.Random();
      _questionNumber = rand.nextInt(_quizData.length);
    } else {
      _questionNumber = 0;
    }
  }

  String getQuestion() {
    return _quizData[_questionNumber].question;
  }

  String getAnswer() {
    return _quizData[_questionNumber].answer;
  }

  String getExplanation() {
    return _quizData[_questionNumber].explanation;
  }

  String getURL() {
    return _quizData[_questionNumber].url;
  }
}
