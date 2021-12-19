import 'package:flutter/material.dart';
import 'package:quizx_app/screens/quiz_screen.dart';

// プログラムの開始
void main() {
  runApp(MyApp());
}

// アプリケーションを定義
class MyApp extends StatelessWidget {
  // アプリケーション全体の作成
  Widget build(BuildContext context) {
    // 初期画面のウィジェット
    return MaterialApp(
      title: 'QuizX',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // テキストのスタイルを設定する
        textTheme: const TextTheme(
          bodyText1: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
              fontSize: 16),
          bodyText2: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.normal,
              decoration: TextDecoration.none,
              fontSize: 25),
        ),
      ),
      home: QuizScreen(),
    );
  }
}
