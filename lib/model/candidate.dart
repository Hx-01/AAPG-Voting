import 'package:firebase_database/firebase_database.dart';

class Candidate{
  String _uid;
  String _name;
  int _votes;
  int _id;

  Candidate(this._uid, this._name, this._votes , this._id);

  Candidate.map(dynamic obj){
    this._uid = obj['uid'];
    this._name = obj['name'];
    this._votes = obj['votes'];
    this._id = obj['id'];
  }

  int get votes => _votes;
  String get name => _name;
  String get uid => _uid;
  int get id => _id;

  Candidate.fromSnapshot(DataSnapshot snapshot){
    _uid = snapshot.key;
    _name = snapshot.value['name'];
    _votes = snapshot.value['votes'];
    _id = snapshot.value['id'];
  }

}

