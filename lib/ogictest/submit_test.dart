import 'package:flutter/material.dart';
import 'package:aapg_voting_1/ogictest/test_start.dart';

class SubmitTest extends StatefulWidget {
  @override
  _SubmitTestState createState() => _SubmitTestState();
}

class _SubmitTestState extends State<SubmitTest> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
      moveToTestScreen();
    },
    child: Scaffold(
      appBar: AppBar(
        title: Text('OGIC 4 Technical Test'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToTestScreen();
            }),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/ogic_test.png'), fit: BoxFit.cover)),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15 , right: 15),
            child: Text(
              'Your Test Has Been Submitted Successfully, Thank You.',
              style: TextStyle(
                color: new Color(0xFF8B1122),
                fontSize: 25,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    ));
  }

  void moveToTestScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TestStart();
    }));
  }
}
