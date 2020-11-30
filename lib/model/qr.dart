import 'package:firebase_database/firebase_database.dart';

class QR{
  String _uid;
  String _ogic;
  String _test;
  String _message;
  String _es3a;

  QR(this._uid, this._ogic , this._test , this._message , this._es3a);

  QR.map(dynamic obj){
    this._uid = obj['uid'];
    this._ogic = obj['ogic'];
    this._test = obj['test'];
    this._message = obj['message'];
    this._es3a = obj['es3a'];
  }

  String get ogic => _ogic;
  String get uid => _uid;
  String get test => _test;
  String get message => _message;
  String get es3a => _es3a;


  QR.fromSnapshot(DataSnapshot snapshot){
    _uid = snapshot.key;
    _ogic = snapshot.value['ogic'];
    _test = snapshot.value['test'];
    _message = snapshot.value['message'];
    _es3a = snapshot.value['es3a'];
  }

}

