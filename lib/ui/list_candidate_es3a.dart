import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListCandidateEs3a extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ListCandidateEs3aState();
  }
}

class _ListCandidateEs3aState extends State<ListCandidateEs3a> {
  AsyncSnapshot _snapshot;
  final CollectionReference collectionReference = Firestore.instance.collection("Votes");
  int selectedValue;
  bool isSelected = false;
  int selectedPosition;
  bool _isDisabled = false;
  SharedPreferences myPref;
  int clickTimes;
  var buttonColour;

  Future getProjects() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection("Projects").getDocuments();
    return qn.documents;
  }

  @override
  void initState() {
    super.initState();
    selectedValue = 0;
    buttonColour = 0xFFFFFFFF;
    _disableButton();
  }

  setSelectedValue(int value) {
    setState(() {
      selectedValue = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(primaryColor: Color(0xFFB2DBE5)),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Es3a 6 Voting'),
            backgroundColor: Color(0xFFB2DBE5),
            elevation: 0,
          ),
          body: Stack(fit: StackFit.expand, children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/back_es3a.png'),
                      fit: BoxFit.fill)),
            ),
            ListView(
              padding: EdgeInsets.only(top: 200),
              children: <Widget>[
                FutureBuilder(
                    future: getProjects(),
                    builder: (_, snapShot) {
                      _snapshot = snapShot;
                      if (!snapShot.hasData) {
                        return Center(child: CircularProgressIndicator(
                          backgroundColor: Color(0xFFB2DBE5),
                        ));
                      } else {
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapShot.data.length,
                            padding: const EdgeInsets.all(10.0),
                            itemBuilder: (context, position) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Card(
                                      elevation: 5,
                                      child: RadioListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.trailing,
                                        title: Text(
                                          snapShot.data[position].data["name"],
                                          style: TextStyle(
                                              fontSize: 25, color: Colors.black),
                                        ),
                                        value: snapShot.data[position].data["id"],
                                        groupValue: selectedValue,
                                        activeColor: Color(0xFFB2DBE9),
                                        onChanged: (value) {
                                          setSelectedValue(value);
                                          isSelected = true;
                                          selectedPosition = position;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      }
                    }),
                AbsorbPointer(
                    absorbing: _isDisabled,
                    child: Container(
                        padding: EdgeInsets.only(bottom: 250, top: 20),
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
                                    textColor: Colors.cyan[200],
                                    onPressed: () async {
                                      if (isSelected == true) {
                                        updateVote(context, selectedPosition , _snapshot);
                                        _showingAlertDialog(
                                           context, selectedPosition , _snapshot);
                                        myPref =
                                            await SharedPreferences.getInstance();
                                        myPref.setInt('clicktimes1', 1);
                                        _disableButton();
                                      } else {
                                        _isDisabled = false;
                                        showSnackBarValidate(context);
                                      }
                                    })))))
              ],
            ),
          ])),
    );
  }

  void _showingAlertDialog(BuildContext context, int position , AsyncSnapshot snapShot) {
    var alertDialoge = AlertDialog(
        title: Text('The Voting Completed Successfully'),
        content: Text('you have been votted to ${snapShot.data[position].data['name']}'));
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

  void updateVote(BuildContext context, int position , AsyncSnapshot snapShot) {
    Map<String, String> data = <String, String>{
      "project_id": "${snapShot.data[position].data['id']}",
    };
    collectionReference.document().setData(data);
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
