
import 'package:cloud_firestore/cloud_firestore.dart';

class EspecialidadeModel{

  String _id;
  String _especialidades;
  String _urlEspecialidade;

  EspecialidadeModel();

  EspecialidadeModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.especialidades = documentSnapshot["especialidades"];
    this.urlEspecialidade = documentSnapshot["urlEspecialidade"];
  }

  EspecialidadeModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference especialidades = db.collection("especialidades");
    this.id = especialidades.document().documentID;

  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "especialidades" : this.especialidades,
      "urlEspecialidade" : this.urlEspecialidade,
    };
    return map;
  }

  String get urlEspecialidade => _urlEspecialidade;

  set urlEspecialidade(String value) {
    _urlEspecialidade = value;
  }

  String get especialidades => _especialidades;

  set especialidades(String value) {
    _especialidades = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}