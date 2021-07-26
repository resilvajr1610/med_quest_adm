import 'package:cloud_firestore/cloud_firestore.dart';

class PerguntaModel{

  String _id;
  String _perguntas;
  String _resposta1;
  String _resposta2;
  String _resposta3;
  String _resposta4;
  String _resposta5;
  //String _respostaCorreta;
  String _explicaoResposta;
  String _urlPergunta;
  String _especialidadePergunta;
  String _temaPergunta;

  PerguntaModel();

  PerguntaModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.documentID;
    this.perguntas = documentSnapshot["perguntas"];
    this.resposta1 = documentSnapshot["resposta1"];
    this.resposta2 = documentSnapshot["resposta2"];
    this.resposta3 = documentSnapshot["resposta3"];
    this.resposta4 = documentSnapshot["resposta4"];
    this.resposta5 = documentSnapshot["resposta5"];
    //this.respostaCorreta = documentSnapshot["respostaCorreta"];
    this.explicaoResposta = documentSnapshot["explicaoResposta"];
    this.urlPergunta = documentSnapshot["urlPergunta"];
    this.especialidadePergunta = documentSnapshot["especialidadePergunta"];
    this.temaPergunta = documentSnapshot["temaPergunta"];
  }

  PerguntaModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference perguntas = db.collection("perguntas");
    this.id = perguntas.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.id,
      "perguntas" : this.perguntas,
      "resposta1" : this.resposta1,
      "resposta2" : this.resposta2,
      "resposta3" : this.resposta3,
      "resposta4" : this.resposta4,
      "resposta5" : this.resposta5,
      //"respostaCorreta" : this.respostaCorreta,
      "explicaoResposta" : this.explicaoResposta,
      "urlPergunta" : this.urlPergunta,
      "especialidadePergunta" : this.especialidadePergunta,
      "temaPergunta" : this.temaPergunta,
    };
    return map;
  }

  String get explicaoResposta => _explicaoResposta;

  set explicaoResposta(String value) {
    _explicaoResposta = value;
  }

  String get resposta1 => _resposta1;

  set resposta1(String value) {
    _resposta1 = value;
  }

  String get temaPergunta => _temaPergunta;

  set temaPergunta(String value) {
    _temaPergunta = value;
  }

  String get especialidadePergunta => _especialidadePergunta;

  set especialidadePergunta(String value) {
    _especialidadePergunta = value;
  }

  String get urlPergunta => _urlPergunta;

  set urlPergunta(String value) {
    _urlPergunta = value;
  }

  String get perguntas => _perguntas;

  set perguntas(String value) {
    _perguntas = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get resposta2 => _resposta2;

  set resposta2(String value) {
    _resposta2 = value;
  }

  String get resposta5 => _resposta5;

  set resposta5(String value) {
    _resposta5 = value;
  }

  String get resposta4 => _resposta4;

  set resposta4(String value) {
    _resposta4 = value;
  }

  String get resposta3 => _resposta3;

  set resposta3(String value) {
    _resposta3 = value;
  }
}