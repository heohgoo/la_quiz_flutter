import 'package:flutter/material.dart';
import 'package:quiz_app_test/model/api_adapter.dart';
import 'package:quiz_app_test/screen/screen_quiz.dart';
import '../model/model_quiz.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Quiz> quizs =[];
  bool isLoading = false;

  _fetchQuizs() async {
    setState(() {
      isLoading = true;
    });
    final response = 
        await http.get(Uri.parse('https://hhg-quiz-test.herokuapp.com/quiz/3/'));
    if(response.statusCode == 200) {
      setState(() {
        quizs = parseQuizs(utf8.decode(response.bodyBytes));
        isLoading = false;
      });
    } else {
      throw Exception('failed to load data');
    }
  }
  // List<Quiz> quizs = [
  //   Quiz.fromMap({
  //     'title': '다음 중 로스트아크의 직업이 아닌 것은?',
  //     'candidates': ['서머너', '아크', '바드', '창술사'],
  //     'answer': 1
  //   }),
  //   Quiz.fromMap({
  //     'title': '다음 중 로스트아크의 군단장이 아닌 것은?',
  //     'candidates': ['발탄', '쿠크세이튼', '카단', '아브렐슈드'],
  //     'answer': 2
  //   }),
  //   Quiz.fromMap({
  //     'title': '다음 중 로스트아크의 에스더가 아닌 것은?',
  //     'candidates': ['진저웨일', '니나브', '실리안', '웨이'],
  //     'answer': 0
  //   }),
  // ];
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = screenSize.width;
    double height = screenSize.height;

   return WillPopScope(
    onWillPop: () async => false,
    child: SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
       appBar:AppBar(
         title: Text('로잘알 모의고사'),
         backgroundColor: Colors.deepPurple,
         leading: Container(),
       ),
       body: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: <Widget>[
           Center(child: Image.asset(
             'Images/Quiz.jpg', 
              width: width*0.8,
           ),
           ),
           Padding(
             padding: EdgeInsets.all(width*0.024),
             ),
             Text('로잘알 퀴즈 앱', style: TextStyle(
               fontSize: width * 0.065,
               fontWeight: FontWeight.bold,
              ),
             ),
             Text(
               '퀴즈를 풀기 전 안내사항입니다.\n꼼꼼히 읽고 퀴즈 풀기를 눌러주세요.',
               textAlign: TextAlign.center,
             ),
             Padding(padding: EdgeInsets.all(width * 0.048),
             ),
             _buildStep(width, '1. 랜덤으로 나오는 퀴즈 3개를 풀어보세요.'),
             _buildStep(width, '2. 문제를 잘 읽고 정답을 고른 뒤\n 다음 문제 버튼을 눌러주세요.'),
             _buildStep(width, '3. 만점을 향해 도전하세요!'),
             Padding(
               padding: EdgeInsets.all(width * 0.048),
             ),
             Container(
               padding: EdgeInsets.only(bottom: width * 0.036),
               child: Center(
                 child: ButtonTheme(
                   minWidth: width * 0.8,
                   height: height * 0.05,
                   shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(10),
                     ),
                   child: RaisedButton(
                       child: Text(
                         '지금 퀴즈 풀기',
                         style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.deepPurple,
                        onPressed: () {
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Row (
                              children: <Widget>[
                                CircularProgressIndicator(),
                                Padding(
                                  padding: EdgeInsets.only(left: width * 0.036),
                                  ),
                                  Text('로딩 중....')
                              ],
                            ),
                            ));
                          _fetchQuizs().whenComplete(() {
                           return Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => QuizScreen(
                                quizs:quizs,
                              ),
                            ),
                           );
                          });
                        },
                    ),
                  ),
                 ),       
             ),
         ],
       ),
      ),
    )
    );
  }

  Widget _buildStep(double width, String title) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        width*0.048, 
        width*0.024, 
        width*0.048, 
        width*0.024,
      ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.check_box,
            size: width * 0.04,
          ),
          Padding(
            padding: EdgeInsets.only(right: width * 0.024),
          ),
          Text(title),
        ],
        ),
    );
  }
}