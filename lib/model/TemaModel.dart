import 'package:cloud_firestore/cloud_firestore.dart';

class TemaModel{

  String _id;
  String _temas;
  String _urlTemas;
  String _especialidadeTema;

  TemaModel();

  TemaModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.temas = documentSnapshot["temas"];
    this.urlTemas = documentSnapshot["urlTema"];
    this.especialidadeTema = documentSnapshot["especialidadeTema"];
  }

  TemaModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference temas = db.collection("temas");
    this.id = temas.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "temas" : this.temas,
      "urlTema" : this.urlTemas,
      "especialidadeTema" : this.especialidadeTema,
    };
    return map;
  }
  Map<String, dynamic> toMapTema(){
    Map<String, dynamic> map = {
    };
    return map;
  }

  String get especialidadeTema => _especialidadeTema;

  set especialidadeTema(String value) {
    _especialidadeTema = value;
  }

  String get urlTemas => _urlTemas;

  set urlTemas(String value) {
    _urlTemas = value;
  }

  String get temas => _temas;

  set temas(String value) {
    _temas = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}