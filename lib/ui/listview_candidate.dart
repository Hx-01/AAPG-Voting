import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:aapg_voting_1/model/candidate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewCandidate extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListViewCandidateState();
  }
}

final candidatesRef = FirebaseDatabase.instance.reference().child("Candidate");

class _ListViewCandidateState extends State<ListViewCandidate> {
  List<Candidate> items;
  StreamSubscription<Event> _onCandidateAddedSubscription;
  int selectedValue;
  bool isSelected = false;
  int selectedPosition;
  bool _isDisabled = false;
  SharedPreferences myPref;
  int clickTimes;
  var buttonColour;

  @override
  void initState() {
    super.initState();

    items = new List();
    _onCandidateAddedSubscription =
        candidatesRef.onChildAdded.listen(_onCandidateAdded);
    selectedValue = 0;
    buttonColour = 0xFF8B1122;

    _disableButton();
  }

  setSelectedValue(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  void dispose() {
    _onCandidateAddedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('OGIC 4 Voting'),
        ),
        body: Stack(fit: StackFit.expand, children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/ogic_voting.png'), fit: BoxFit.cover)),
          ),
          ListView(
            padding: EdgeInsets.only(top: 200),
            children: <Widget>[
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
                          controlAffinity: ListTileControlAffinity.trailing,
                          title: Text(
                            '${items[position].name}',
                            style: TextStyle(
                                fontSize: 25, color: Colors.black),
                          ),
                          value: items[position].id,
                          groupValue: selectedValue,
                          activeColor: new Color(0xFF8B1122),
                          onChanged: (value) {
                            setSelectedValue(value);
                            isSelected = true;
                            selectedPosition = position;
                          },
                        ),
                      ],
                    );
                  }),
              AbsorbPointer(
                  absorbing: _isDisabled,
                  child: Container(
                      padding: EdgeInsets.only(bottom: 250, top: 15),
                      alignment: Alignment.bottomCenter,
                      child: ButtonTheme(
                          minWidth: 200,
                          height: 50,
                          child: Builder(
                              builder: (context) => RaisedButton(
                                  child: Text(
                                    'Vote',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  color: new Color(buttonColour),
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (isSelected == true) {
                                      updateVote(context, selectedPosition);
                                      _showingAlertDialog(
                                          context, selectedPosition);
                                      myPref = await SharedPreferences
                                          .getInstance();
                                      myPref.setInt('clicktimes1', 1);
                                      _disableButton();
                                    } else {
                                      _isDisabled = false;
                                      showSnackBarValidate(context);
                                    }
                                  })))))
            ],
          ),
        ]));
  }

  void _onCandidateAdded(Event event) {
    setState(() {
      items.add(new Candidate.fromSnapshot(event.snapshot));
    });
  }

  void _showingAlertDialog(BuildContext context, int position) {
    var alertDialoge = AlertDialog(
        title: Text('The Voting Completed Successfully'),
        content: Text('you have been votted to ${items[position].name}'));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialoge;
        });
  }

  void showSnackBarValidate(BuildContext context) {
    var snackBar = SnackBar(content: Text('Please Choose Competitor'));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void updateVote(BuildContext context, int position) {
    int vote = items[position].votes;
    vote++;
    candidatesRef.child('${items[position].uid}').update({'votes': vote});
  }

  _disableButton() async {
    myPref = await SharedPreferences.getInstance();
    clickTimes = myPref.getInt('clicktimes1');
    if (clickTimes != 1) {
      setState(() {
        _isDisabled = false;
      });
      print('false');
    } else {
      setState(() {
        _isDisabled = true;
        buttonColour = 0xFF757575;
      });
      print('true');
    }
  }
}
