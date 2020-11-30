import 'package:firebase_database/firebase_database.dart';

class Test{
  String _name;
  String _answer1;
  String _answer2;
  String _answer3;
  String _answer4;
  String _answer5;
  String _answer6;
  String _answer7;
  String _answer8;
  String _answer9;
  String _answer10;

  Test(this._name, this._answer1, this._answer2, this._answer3,
      this._answer4, this._answer5, this._answer6, this._answer7, this._answer8,
      this._answer9, this._answer10);

  Test.map(dynamic obj){
    this._name = obj['name'];
    this._answer1 = obj['answer1'];
    this._answer2 = obj['answer2'];
    this._answer3 = obj['answer3'];
    this._answer4 = obj['answer4'];
    this._answer5 = obj['answer5'];
    this._answer6 = obj['answer6'];
    this._answer7 = obj['answer7'];
    this._answer8 = obj['answer8'];
    this._answer9 = obj['answer9'];
    this._answer10 = obj['answer10'];
  }

  String get answer10 => _answer10;

  String get answer9 => _answer9;

  String get answer8 => _answer8;

  String get answer7 => _answer7;

  String get answer6 => _answer6;

  String get answer5 => _answer5;

  String get answer4 => _answer4;

  String get answer3 => _answer3;

  String get answer2 => _answer2;

  String get answer1 => _answer1;

  String get name => _name;



  Test.fromSnapshot(DataSnapshot snapshot){
    _name = snapshot.key;
    _answer1 = snapshot.value['answer1'];
    _answer2 = snapshot.value['answer2'];
    _answer3 = snapshot.value['answer3'];
    _answer4 = snapshot.value['answer4'];
    _answer5 = snapshot.value['answer5'];
    _answer6 = snapshot.value['answer6'];
    _answer7 = snapshot.value['answer7'];
    _answer8 = snapshot.value['answer8'];
    _answer9 = snapshot.value['answer9'];
    _answer10 = snapshot.value['answer10'];
  }

}