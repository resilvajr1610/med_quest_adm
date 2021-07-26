import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel{

  String _idUsuario = "";
  String _email = "";
  String _nome = "";
  String _sobreNome = "";
  String _crm = "";
  String _especialidade = "";
  String _urlCRMFrente = "";
  String _urlCRMVerso = "";
  String _status = "";
  int _corretas = 0;
  int _incorretas = 0;
  String _tokenID = "";

  UsuarioModel();

  UsuarioModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.idUsuario = documentSnapshot.documentID;
    this.nome = documentSnapshot["nome"];
    this.status = documentSnapshot["status"];
    this.sobreNome = documentSnapshot["sobreNome"];
    this.email = documentSnapshot["email"];
    this.crm = documentSnapshot["crm"];
    this.especialidade = documentSnapshot["especialidade"];
    this.urlCRMFrente = documentSnapshot["urlCRMFrente"];
    this.urlCRMVerso = documentSnapshot["urlCRMVerso"];
    this.corretas = documentSnapshot["corretas"];
    this.incorretas = documentSnapshot["incorretas"];
    this.tokenID = documentSnapshot["tokenID"];
  }

  UsuarioModel.gerarId(){
    Firestore db = Firestore.instance;
    CollectionReference perguntas = db.collection("perguntas");
    this.idUsuario = perguntas.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      "id" : this.idUsuario,
      "nome" : this.nome,
      "sobreNome" : this.sobreNome,
      "email" : this.email,
      "status" : this.status,
      "corretas" : this.corretas,
      "incorretas" : this.incorretas,
      "tokenID" : this.tokenID,
    };
    return map;
  }

  String get tokenID => _tokenID;

  set tokenID(String value) {
    _tokenID = value;
  }

  int get corretas => _corretas;

  set corretas(int value) {
    _corretas = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get especialidade => _especialidade;

  set especialidade(String value) {
    _especialidade = value;
  }

  String get crm => _crm;

  set crm(String value) {
    _crm = value;
  }

  String get sobreNome => _sobreNome;

  set sobreNome(String value) {
    _sobreNome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }

  String get urlCRMFrente => _urlCRMFrente;

  set urlCRMFrente(String value) {
    _urlCRMFrente = value;
  }

  String get urlCRMVerso => _urlCRMVerso;

  set urlCRMVerso(String value) {
    _urlCRMVerso = value;
  }

  int get incorretas => _incorretas;

  set incorretas(int value) {
    _incorretas = value;
  }
}