import 'package:flutter/material.dart';
import 'package:form/quizpage.dart';
import 'signup.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

    @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Quiz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(

      ),
      // ignore: unrelated_type_equality_checks
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => Signup(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/Quiz': (context) => QuizData(),
        //ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen()
      },
    );
  }

}




