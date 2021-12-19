import 'question.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class QuizBrain {
  int _questionNumber = 0;
  List<Question> _quizData = []; //データ

  void loadQuizData(List<Map<String, dynamic>> dataList) {
    _quizData = dataList
        .map((Map<String, dynamic> data) => Question.fromJson(data))
        .toList();
  }

  void nextQuestion() {
    if (_questionNumber < _quizData.length - 1) {
      _questionNumber++;
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
