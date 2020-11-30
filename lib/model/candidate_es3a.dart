import 'package:cloud_firestore/cloud_firestore.dart';

class CandidateEs3a{
  String _name;
  int _id;

  CandidateEs3a( this._name,  this._id);

  CandidateEs3a.map(dynamic obj){
    this._name = obj['name'];
    this._id = obj['id'];
  }

  String get name => _name;
  int get id => _id;

  CandidateEs3a.fromSnapshot(DocumentSnapshot snapshot){
    _name = snapshot.data['name'];
    _id = snapshot.data['id'];
  }

}

