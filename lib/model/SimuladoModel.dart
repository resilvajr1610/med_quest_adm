import 'package:cloud_firestore/cloud_firestore.dart';

class SimuladoModel{
  String _id;
  String _questoes;
  String _tempo;

  SimuladoModel();

  SimuladoModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.questoes = documentSnapshot["questoes"];
    this.tempo = documentSnapshot["tempo"];
  }

  SimuladoModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference planos = db.collection("simulado");
    this.id = planos.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "questoes" : this.questoes,
      "tempo" : this.tempo,
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get tempo => _tempo;

  set tempo(String value) {
    _tempo = value;
  }

  String get questoes => _questoes;

  set questoes(String value) {
    _questoes = value;
  }

}