import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:form/utility.dart';
import 'package:form/constants.dart';


class QuizData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context)
          .loadString(jsonFilePath, cache: false),
      builder: (context, snapshot) {
        List quizData = json.decode(snapshot.data.toString());
        Map studentDetails = ModalRoute.of(context).settings.arguments;
        if (quizData == null) {
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));

          return Center(child: CircularProgressIndicator());
        } else {
          return Quiz(quizData: quizData, studentDetails:studentDetails);
        }
      },
    );
  }
}

// ignore: must_be_immutable
class Quiz extends StatefulWidget {
  List quizData;
  Map studentDetails;
  Quiz({Key key, @required this.quizData,@required this.studentDetails}) : super(key: key);

  @override
  _QuizState createState() => _QuizState(quizData,studentDetails);
}

class _QuizState extends State<Quiz> {
  List quizData;
  Map studentDetails;
  _QuizState(this.quizData,this.studentDetails);
  Color colorToShow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int questionNo = 1;
  String buttonText = nextQuestionStr;
  String selectedOption;
  String _groupValue = 1.toString();
  bool isOptionSelected = false;
  Map questionAnswerMap = new HashMap<int, String>();

  void nextQuestion() {
    setState(() {
      isOptionSelected = false;
      selectedOption = "";
      if (questionNo < quizData[0].length) {
        questionNo += 1;
        _groupValue = questionNo.toString();
      } else {
        checkAnswers();
        FileUtility.save(marks.toString());
        Navigator.pop(context);
      }
      if (questionNo == quizData[0].length)
        buttonText = doneStr;
      else if (questionNo < quizData[0].length) buttonText = nextQuestionStr;
    });
  }

  void checkAnswers() {
    setState(() {
      int i = 1;
      while (i <= questionNo) {
        if (questionAnswerMap[i] == quizData[2][i.toString()]) marks = marks + 1;
        i++;
      }
    });
  }

  Widget choice(String k) {
    return RadioListTile(
      title: Text(quizData[1][questionNo.toString()][k]),
      value: quizData[1][questionNo.toString()][k],
      groupValue: _groupValue,
      activeColor: Colors.redAccent,
      selected: false,
      onChanged: (value) {
        setState(() {
          isOptionSelected = true;
          _groupValue = value;
          questionAnswerMap[questionNo] = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (questionNo <= 1)
          Navigator.pop(context);
        else {
          setState(() {
            questionNo = questionNo - 1;
          });
        }
      },
      child: Scaffold(
          backgroundColor: Colors.orange,
          appBar: AppBar(
            title: Text('Quiz'),
          ),
          body: Container(

              height:MediaQuery.of(context).size.height* 0.8,
            child: Card(

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Candidate Name:"+" "+
                          studentDetails['firstname'].toString()+" "+studentDetails['lastname'].toString(),
                          style: TextStyle(
                            fontSize: 14.0,

                          ),
                        ),
                        Text(" "+
                          questionNo.toString() +
                              "." +
                              " " +
                              quizData[0][questionNo.toString()],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                      ],
                    )),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          choice('a'),
                          choice('b'),
                          choice('c'),
                          choice('d')
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                          child: Column(children: <Widget>[
                        Visibility(
                          visible: isOptionSelected,
                          child: ButtonTheme(
                            height: 40.0,
                            minWidth: 200,
                            child: RaisedButton(
                              onPressed: nextQuestion,
                              color: Colors.redAccent,
                              child: Text(
                                buttonText,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            ),
                          ),
                        )
                      ])))
                ],
              ),
            ),
          )),
    );
  }
}
