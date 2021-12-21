import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizx_app/models/quiz_brain.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({Key? key}) : super(key: key);
  // ステートを管理する部品の定義
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

// 更新が必要なことを通知する
class _QuizScreenState extends State<QuizScreen> {
  final QuizBrain _quizBrain = QuizBrain();

  var _isVisible = false;
  var _answerButtonType = 0;
  var _answerButtonText = 'slash';

  var charIndex = 0.0;
  var _fullQuestionLabel = '';
  var _fullQuestionLabelWithSlash = '';
  var _questionLabel = '';
  var _answerLabel = '';
  var _explanationLabel = '';
  var _slashFlag = false;
  var _questionShowsAllFlag = false;

  var _shareURL = "";
  var _shareQuestion = "";

  /*
   * ローカルJSONファイル読み込み
   */
  Future<String> _loadAVaultAsset() async {
    return await rootBundle.loadString('json/quizData_20211220.json');
  }

  /*
   * ローカルJSON　データセット
   */
  Future getLocalTestJSONData() async {
    String jsonString = await _loadAVaultAsset();
    setState(() {
      var encoded = json.decode(jsonString);
      List<Map<String, dynamic>> questionList =
          List<Map<String, dynamic>>.from(encoded["quizDataSet"]);
      _quizBrain.loadQuizData(questionList);
    });
  }

  void _answerButtonPressed() {
    setState(() {
      switch (_answerButtonType) {
        case 0:
          _slashFlag = true;
          _shareURL = _quizBrain.getURL();
          _isVisible = true;

          if (_questionShowsAllFlag) {
            _questionLabel = _fullQuestionLabelWithSlash;
          }

          _answerButtonType = 1;
          _answerButtonText = 'answer';
          break;
        case 1:
          _answerLabel = _quizBrain.getAnswer();
          _explanationLabel = _quizBrain.getExplanation();
          if (_questionShowsAllFlag) {
            _questionLabel = _fullQuestionLabelWithSlash;
            _answerButtonType = 5;
            _answerButtonText = 'next';
          } else {
            _answerButtonType = 2;
            _answerButtonText = '.....';
          }
          break;
        case 2:
          break;
        default:
          _quizBrain.nextQuestion();
          _fullQuestionLabel = _quizBrain.getQuestion();
          _questionLabel = '';
          _answerLabel = '';
          _explanationLabel = '';
          _isVisible = false;
          _answerButtonType = 0;
          _answerButtonText = 'slash';
          _slashFlag = false;
          _questionShowsAllFlag = false;
          _addCharacter();
      }
    });
  }

  // 更新されるウィジェットの作成
  @override
  Widget build(BuildContext context) {
    // 設定されているTextThemeを取得
    final textTheme = Theme.of(context).textTheme;
    // 設定されているテーマを上書きする
    final boldStyle = textTheme.bodyText1
        ?.copyWith(color: Colors.redAccent, fontWeight: FontWeight.bold);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        // Builderウィジェットを使う
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Drawerを開く処理
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            child: Text(
              _questionLabel,
              style: textTheme.bodyText1,
            ),
            color: Colors.amberAccent,
            height: 300,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
          ),
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  child: Text(
                    _answerLabel,
                    style: boldStyle,
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                ),
                Container(
                  child: Text(
                    _explanationLabel,
                    style: boldStyle,
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  alignment: Alignment.center,
                ),
              ]),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  )),
              onPressed: _answerButtonPressed,
              child: Text(
                _answerButtonText,
                style: textTheme.bodyText2,
              ),
            ),
            color: Colors.amberAccent,
            height: 120,
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          child: const Icon(MdiIcons.twitter),
          backgroundColor: Colors.lightBlueAccent,
          onPressed: () {
            _tweet();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text("QuizXについて")),
            ListTile(
              title: const Text("Webサイト"),
              onTap: () {
                _website();
              },
            ),
            ListTile(
              title: const Text("公式Twitter"),
              onTap: () {
                _officialTwitter();
              },
            ),
            ListTile(
              title: const Text('プライバシーポリシー'),
              onTap: () {
                _privacyPolicy();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _website() async {
    final Uri tweetIntentUrl = Uri.https('quizx.net', '/');
    await launch(tweetIntentUrl.toString());
  }

  void _officialTwitter() async {
    final Uri tweetIntentUrl = Uri.https('twitter.com', '/QuizXix');
    await launch(tweetIntentUrl.toString());
  }

  void _privacyPolicy() async {
    final Uri tweetIntentUrl = Uri.https('quizx.net', '/privacy-policy');
    await launch(tweetIntentUrl.toString());
  }

  void _tweet() async {
    final Map<String, dynamic> tweetQuery = {
      'text': _shareQuestion + '\n\n#早押しQuizX\n',
      'url': _shareURL,
    };

    final Uri tweetScheme =
        Uri(scheme: 'twitter', host: 'post', queryParameters: tweetQuery);

    final Uri tweetIntentUrl =
        Uri.https('twitter.com', '/intent/tweet', tweetQuery);

    await canLaunch(tweetScheme.toString())
        ? await launch(tweetScheme.toString())
        : await launch(tweetIntentUrl.toString());
  }

  void _addCharacter() {
    String allChar = '';
    String allCharWithSlash = '';
    var _isSlashAdd = false;
    for (var i = 0; i < _fullQuestionLabel.length; i++) {
      String char = _fullQuestionLabel[i];
      Timer(
          Duration(milliseconds: 100 * i),
          () => {
                setState(() {
                  allChar = allChar + char;
                  if (!_slashFlag) {
                    _questionLabel = allChar;
                  } else {
                    if (!_isSlashAdd) {
                      allCharWithSlash = allChar + ' / ';
                      _shareQuestion = allCharWithSlash;
                      _questionLabel = allCharWithSlash;
                      _isSlashAdd = true;
                    } else {
                      allCharWithSlash = allCharWithSlash + char;
                    }
                  }
                  if (allChar == _fullQuestionLabel) {
                    if (!_isSlashAdd) {
                      allCharWithSlash = allChar + ' / ';
                      _shareQuestion = allCharWithSlash;
                    }
                    _fullQuestionLabelWithSlash = allCharWithSlash;
                    _questionShowsAllFlag = true;
                    if (_answerButtonType == 2) {
                      _questionLabel = allCharWithSlash;
                      _answerButtonType = 5;
                      _answerButtonText = 'next';
                    }
                  }
                })
              });
    }
  }

  @override
  void initState() {
    super.initState();
    //ローカルJSON
    getLocalTestJSONData();
    // _fullQuestionLabel = _quizBrain.getQuestion();
    _answerLabel = '';
    _explanationLabel = '';
    _isVisible = false;
    _answerButtonType = 5;
    _answerButtonText = 'start';
  }
}
