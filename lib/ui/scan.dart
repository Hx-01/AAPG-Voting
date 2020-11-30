import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:aapg_voting_1/ui/listview_candidate.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:aapg_voting_1/model/qr.dart';
import 'package:aapg_voting_1/ogictest/test_start.dart';
import 'package:aapg_voting_1/ui/list_candidate_es3a.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

final QRRef = FirebaseDatabase.instance.reference().child("QR");

class _HomePageState extends State<HomePage> {
  QR qr;
  StreamSubscription<Event> _onDataAddedSubscription;
  String ogicResult;
  String es3aResult;
  String testResult;
  String qrResult;
  String message;
  String messageFromFireBase;

  @override
  void initState() {
    super.initState();
    _onDataAddedSubscription = QRRef.onChildAdded.listen(_onDataAdded);
    message = '';
    messageFromFireBase = '';
  }

  @override
  void dispose() {
    _onDataAddedSubscription.cancel();
    super.dispose();
  }

  Future _scanQR() async {
    try {
      qrResult = await BarcodeScanner.scan();
      setState(() {
        navigateToScreen();
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          message = "Camera permission was denied";
        });
      } else {
        setState(() {
          message = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        message = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        message = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          closeApp();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('AAPG Voting'),
            centerTitle: true,
            leading: Container(),
          ),
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/cover_voting.png'),
                        fit: BoxFit.cover)),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 110),
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  alignment: Alignment.bottomCenter,
                  padding: EdgeInsets.only(bottom: 50),
                  child: ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child: RaisedButton(
                        elevation: 6,
                        color: Colors.white,
                        textColor: new Color(0xFF8B1122),
                        child: Text(
                          'Scan',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        onPressed: _scanQR),
                  ))
            ],
          ),
        ));
  }

  void navigateToScreen() {
    if (ogicResult == qrResult) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ListViewCandidate();
      }));
    } else if (es3aResult == qrResult) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return ListCandidateEs3a();
      }));
    } else if (testResult == qrResult) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TestStart();
      }));
    } else if (es3aResult != qrResult) {
      message = messageFromFireBase;
    } else {
      message = 'Something Went Wrong, Check Your Internet Connection.';
    }
  }

  void _showingSnackBar(BuildContext context) {
    var snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _onDataAdded(Event event) {
    setState(() {
      qr = new QR.fromSnapshot(event.snapshot);
      ogicResult = qr.ogic;
      testResult = qr.test;
      es3aResult = qr.es3a;
      messageFromFireBase = qr.message;
    });
  }

  void closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
