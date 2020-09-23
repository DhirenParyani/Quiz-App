import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:form/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String firstName, lastName, nickname;
  int age;
  int score = 0;
  int totalMarks = 0;
  String title=informationEditedTitle;
  bool _scoreAvailable = false;
  bool _isFieldsEditable = false;
  final _formKey = GlobalKey<FormState>();
  String buttonText=InfoEditButtonText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: SingleChildScrollView(

        child: Form(

          key: _formKey,

          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: FutureBuilder<bool>(
                future: _getPrefData(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.hasData) {
                    child:
                    return Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                      Text(
                        title,
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: firstName,
                          keyboardType: TextInputType.text,
                          enabled: _isFieldsEditable,
                          // ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) {
                              return firstNameError;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                          ),
                          onSaved: (input) => this.firstName = input,
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: lastName,
                          enabled: _isFieldsEditable,
                          keyboardType: TextInputType.text,
                          // ignore: missing_return
                          validator: (input) {
                            if (input.isEmpty) {
                              return lastNameError;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                          ),
                          onSaved: (input) => this.lastName = input,
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: nickname,
                          enabled: _isFieldsEditable,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                          if (input.isEmpty) {
                          return nickNameError;
                          }},
                          decoration: InputDecoration(
                            labelText: 'Nickname',
                          ),
                          onSaved: (input) {
                            setState(() {
                              this.nickname = input;
                            });
                           },
                        ),
                      ),
                      ListTile(
                        title: TextFormField(
                          initialValue: (age==0)?"":age.toString(),
                          keyboardType: TextInputType.number,
                          enabled: _isFieldsEditable,
                            validator: (input) {
                            if (input.isEmpty) {
                            return ageError;
                            }
                            else if(num.parse(input)<=0 || num.parse(input)>=200)
                              return ageRangeError;


                            },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            labelText: 'Age',
                          ),
                          onSaved: (input) => this.age = num.parse(input),
                        ),
                      ),
                      Visibility(
                        child: Text("Last Attempt Score:" +" "+ score.toString(),
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold

                          ),
                        ),
                        visible: _scoreAvailable,
                      ),
                      ButtonTheme(
                        height: 40.0,
                        minWidth: 200,
                        child: RaisedButton(
                          onPressed:(_isFieldsEditable)?() async{
                            // ignore: unnecessary_statements
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();
                              bool result = await _saveToPhone()
                              // ignore: unnecessary_statements

                              ;
                            setState(()  {

                              buttonText = InfoEditButtonText;
                              title=informationUnEditedTitle;
                              _isFieldsEditable = !_isFieldsEditable;

                            });
                              }
                          }:(){
                            setState(() {
                              title=informationEditedTitle;
                               buttonText=InfoEditDoneButtonText;
                               _isFieldsEditable=!_isFieldsEditable;
                            });
                          },
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
                      ButtonTheme(
                        height: 40.0,
                        minWidth: 200,
                        child: RaisedButton(

                          onPressed:(_isFieldsEditable || (this.firstName==null||this.firstName==''))?null:() => Navigator.pushNamed(context, '/Quiz',
                              arguments: {
                                'firstname': firstName,
                                'lastname': lastName,
                                'age': age,
                                'nickname': nickname
                              }),
                          color: Colors.redAccent,
                          child: Text(
                            'Start Quiz',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                      ),
                    ]);
                  }
                  return CircularProgressIndicator();
                }),
          ),
        ),
      ),
    );
  }

  Future<bool> _saveToPhone() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("firstname");
    prefs.remove("lastname");
    prefs.remove("nickname");
    prefs.remove("age");
    prefs.setString("firstname",this.firstName);
    prefs.setString("lastname", this.lastName);
    prefs.setString("nickname", this.nickname);
    prefs.setInt("age", age);
    return true;
  }



  Future<bool> _getPrefData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Directory directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/score.txt');
    bool isFileAvailable = await file.exists();
    String score = "";
    if (isFileAvailable) score = await file.readAsString();
    setState(() {
      this.firstName =
          prefs.containsKey('firstname') ? prefs.getString("firstname") : "";
      this.lastName =
          prefs.containsKey('lastname') ? prefs.getString("lastname") : "";
      this.nickname =
          prefs.containsKey('nickname') ? prefs.getString("nickname") : "";
      this.age = prefs.containsKey('age') ? prefs.getInt("age") : 0;
      _scoreAvailable = isFileAvailable;
      if (_scoreAvailable) this.score = num.parse(score);
      if(firstName=="") {
        _isFieldsEditable = true;
        buttonText=doneStr;
      }
       if(_isFieldsEditable) {
        title = informationEditedTitle;
      }
      else  title=informationUnEditedTitle;

    });
    return true;
  }
}
