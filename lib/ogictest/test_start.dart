import 'package:flutter/material.dart';
import 'package:aapg_voting_1/ogictest/first_question.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aapg_voting_1/ui/scan.dart';

class TestStart extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TestStartState();
  }
}

class _TestStartState extends State<TestStart> {
  final testRef = FirebaseDatabase.instance.reference().child("Test");
  var _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  String name;
  ScrollController _scrollController = new ScrollController();

  Widget build(BuildContext context) {
    TextStyle nameStyle = Theme.of(context).textTheme.title;
    return WillPopScope(
        onWillPop: () {
      moveToLastScreen();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('OGIC 4 Technical Test'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            }),
      ),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/ogic_test.png'), fit: BoxFit.cover)),
          ),
          Form(
              key: _formKey,
              child: Padding(
                padding:
                    EdgeInsets.only(top: 200, bottom: 40, left: 15, right: 15),
                child: ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  controller: _scrollController,
                  children: <Widget>[
                    TextFormField(
                      controller: nameController,
                      style: nameStyle,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Please Enter Your Name';
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: 'Enter Your Name',
                          labelStyle: nameStyle,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    Container(
                        alignment: Alignment.bottomCenter,
                        padding: EdgeInsets.only(top: 60),
                        child: ButtonTheme(
                          minWidth: 200,
                          height: 50,
                          child: RaisedButton(
                              elevation: 6,
                              color: new Color(0xFF8B1122),
                              textColor: Colors.white,
                              child: Text(
                                'Start',
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (_formKey.currentState.validate()) {
                                    _createUser();
                                    _navigateToFirstQuestion();
                                  }
                                });
                              }),
                        ))
                  ],
                ),
              ))
        ],
      ),
    ));
  }

  void _navigateToFirstQuestion() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return FirstQuestion(
        nameFromTextField: name,
      );
    }));
  }

  void _createUser() {
    name = nameController.text;
    testRef.child(name).set({
      'answer1': "",
      'answer2': "",
      'answer3': "",
      'answer4': "",
      'answer5': "",
      'answer6': "",
      'answer7': "",
      'answer8': "",
      'answer9': "",
      'answer10': "",
    });
  }

  void moveToLastScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return HomePage();
    }));
  }
}
