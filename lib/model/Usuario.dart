import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario{

  String _idUsuario = "";
  String _email = "";
  String _senha = "";
  String _nome = "";
  String _sobreNome = "";
  String _status = "";
  String _idOneSignal = "";

  Usuario();

  Map<String,dynamic> toMap(){
    Map<String,dynamic> map = {
      "idUsuario" : this.idUsuario,
      "email" : this.email,
      "status" : this.status,
      "idOneSignal" : this.idOneSignal,
    };
    return map;
  }

  String get idOneSignal => _idOneSignal;

  set idOneSignal(String value) {
    _idOneSignal = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  String get sobreNome => _sobreNome;

  set sobreNome(String value) {
    _sobreNome = value;
  }

  String get nome => _nome;

  set nome(String value) {
    _nome = value;
  }

  String get senha => _senha;

  set senha(String value) {
    _senha = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}