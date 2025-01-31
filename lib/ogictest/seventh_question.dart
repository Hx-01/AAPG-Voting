import 'package:flutter/material.dart';
import 'package:aapg_voting_1/ogictest/test_start.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:aapg_voting_1/model/test.dart';
import 'eighth_question.dart';

class SeventhQuestion extends StatefulWidget {
  final String nameFromTextField;

  SeventhQuestion({Key key, this.nameFromTextField}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SeventhQuestionState();
  }
}

final testRef = FirebaseDatabase.instance.reference().child("Test");

class _SeventhQuestionState extends State<SeventhQuestion> {
  List<String> getListElements() {
    List<String> list = List<String>();
    list.add('Bullnose');
    list.add('Section Mill');
    list.add('Orienting Sub');
    return list;
  }

  var items;
  int selectedValue;
  bool isSelected = false;
  int selectedPosition;
  Test test;
  StreamSubscription<Event> _onDataAddedSubscription;
  int timer = 30;
  String showTimer = "30";
  String showName;
  bool stopTimer = false;

  @override
  void initState() {
    super.initState();
    selectedValue = 0;
    _onDataAddedSubscription = testRef.onChildAdded.listen(_onDataAdded);
    startTimer();
    showName = widget.nameFromTextField;
  }

  @override
  void dispose() {
    _onDataAddedSubscription.cancel();
    super.dispose();
  }

  setSelectedValue(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    items = getListElements();
    return WillPopScope(
        onWillPop: () {
          moveToTestScreen();
          stopTimer = true;
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text('OGIC 4 Technical Test'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    moveToTestScreen();
                    stopTimer = true;
                  }),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/ogic_test.png'),
                          fit: BoxFit.cover)),
                ),
                ListView(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 15, bottom: 15, top: 150),
                      child: Text(
                        '00:$showTimer',
                        style: TextStyle(
                          fontSize: 30,
                          color: new Color(0xFF8B1122),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Text(
                        'Q7: It is used to guide a hole opener or underreamer, particularly in deviated pilot holes.',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: items.length,
                        padding: const EdgeInsets.all(10.0),
                        itemBuilder: (context, position) {
                          return Column(
                            children: <Widget>[
                              Divider(height: 6, color: Colors.black),
                              RadioListTile(
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                title: Text(
                                  '${items[position]}',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                ),
                                value: position + 1,
                                groupValue: selectedValue,
                                activeColor: new Color(0xFF8B1122),
                                onChanged: (value) {
                                  setSelectedValue(value);
                                  isSelected = true;
                                  selectedPosition = position;
                                  print('${items[position]}');
                                },
                              ),
                            ],
                          );
                        }),
                    Container(
                        padding: EdgeInsets.only(bottom: 180, top: 10),
                        alignment: Alignment.bottomCenter,
                        child: ButtonTheme(
                            minWidth: 200,
                            height: 50,
                            child: Builder(
                                builder: (context) => RaisedButton(
                                    child: Text(
                                      'Next',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25),
                                    ),
                                    color: new Color(0xFF8B1122),
                                    textColor: Colors.white,
                                    onPressed: () {
                                      if (isSelected == true) {
                                        _updateAnswer(
                                            context, selectedPosition);
                                        navigateToNextQuestion();
                                        stopTimer = true;
                                      } else {
                                        showSnackBarValidate(context);
                                      }
                                    }))))
                  ],
                ),
              ],
            )));
  }

  void moveToTestScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TestStart();
    }));
  }

  void showSnackBarValidate(BuildContext context) {
    var snackBar = SnackBar(content: Text('Please Choose Answer'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _onDataAdded(Event event) {
    setState(() {
      test = new Test.fromSnapshot(event.snapshot);
    });
  }

  void _updateAnswer(BuildContext context, int position) {
    String finalAnswer = items[position];
    testRef.child('$showName').update({'answer7': finalAnswer});
  }

  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer t) {
      setState(() {
        if (stopTimer == true) {
          t.cancel();
        } else if (timer < 1) {
          t.cancel();
          navigateToNextQuestion();
        } else {
          timer = timer - 1;
        }
        showTimer = timer.toString();
      });
    });
  }

  void navigateToNextQuestion() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EighthQuestion(
        nameFromTextField: showName,
      );
    }));
  }
}
