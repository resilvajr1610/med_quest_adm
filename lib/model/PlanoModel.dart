import 'package:cloud_firestore/cloud_firestore.dart';

class PlanoModel{
  String _id;
  String _mensal;
  String _trimestral;
  String _anual;

  PlanoModel();

  PlanoModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.mensal = documentSnapshot["mensal"];
    this.trimestral = documentSnapshot["trimestral"];
    this.anual = documentSnapshot["anual"];
  }

  PlanoModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference planos = db.collection("planos");
    this.id = planos.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "mensal" : this.mensal,
      "trimestral" : this.trimestral,
      "anual" : this.anual
    };
    return map;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get anual => _anual;

  set anual(String value) {
    _anual = value;
  }

  String get trimestral => _trimestral;

  set trimestral(String value) {
    _trimestral = value;
  }

  String get mensal => _mensal;

  set mensal(String value) {
    _mensal = value;
  }


}