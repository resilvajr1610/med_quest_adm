import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/SimuladoModel.dart';
import '../main.dart';

class Simulados extends StatefulWidget {

  @override
  _SimuladosState createState() => _SimuladosState();
}

class _SimuladosState extends State<Simulados> {

  SimuladoModel _simuladoModel = SimuladoModel();
  TextEditingController _controllerQuestoes = TextEditingController();
  TextEditingController _controllerTempo = TextEditingController();
  String _mensagemErro = "";
  String _mensagem = "";
  String _tempo;
  String _questoes;

  @override
  void initState() {
    super.initState();
    _recuperarDadosSimulado();
    //_simuladoModel = SimuladoModel().gerarId();
  }
  _recuperarDadosSimulado()async{

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await
    db.collection("simulado")
        .document("simulado")
        .get();

    Map<String,dynamic> dados = snapshot.data;
    setState(() {
      _mensagemErro = "";
      _tempo = dados["tempo"].toString();
      _questoes = dados["questoes"].toString();
      _controllerQuestoes = TextEditingController(text: _questoes);
      _controllerTempo = TextEditingController(text: _tempo);
    });
  }

  _salvar(){
    //salvar firebase
    String questoes = _controllerQuestoes.text;
    String tempo = _controllerTempo.text;

    _simuladoModel.questoes= questoes;
    _simuladoModel.tempo= tempo;

    Firestore db = Firestore.instance;
    db.collection("simulado")
        .document("simulado")
        .setData(_simuladoModel.toMap()).then((_) {

      setState(() {
        _mensagem = "Valores salvos com sucesso!";
      });

    });
  }

  _validarCampos() {
    //recuperar dados dos campos
    _questoes = _controllerQuestoes.text;
    _tempo = _controllerTempo.text;

    if (_questoes.isNotEmpty) {
      if (_tempo.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
          _questoes = "";
          _tempo = "";
        });
        _salvar();
      } else {
        setState(() {
          _mensagemErro = "Preencha o quantidade de tempo";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha a quantidade de questões";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        backgroundColor: temaPadrao.primaryColor,
        title: Image.asset(
          "assets/imagens/logoOficial.png",
          alignment: Alignment.center,
          width: 450,
          height: 150,
        ),
      ),
      body: Container(
          padding: EdgeInsets.all(5),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text("Simulado",
                      style: TextStyle(fontSize: 25,
                          color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
                ),
                Padding(
                  padding:EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text( "Quantidade de Questões",
                        style: TextStyle(color: temaPadrao.accentColor, fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 110,left: 110),
                  child: TextField(
                      controller: _controllerQuestoes,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding:EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    child: Text( "Tempo em minutos",
                        style: TextStyle(color: temaPadrao.accentColor, fontSize: 20)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 110,left: 110),
                  child: TextField(
                      controller: _controllerTempo,
                      keyboardType: TextInputType.number,
                      style: TextStyle(fontSize: 15),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 5, 32, 5),
                          focusedBorder: InputBorder.none,
                          filled: true,
                          fillColor: temaPadrao.secondaryHeaderColor,
                          enabledBorder: OutlineInputBorder(borderRadius:BorderRadius.circular(32),
                              borderSide: BorderSide(color: Colors.white,width: 0))
                      )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, bottom: 10),
                  child: RaisedButton(
                      child: Text(
                        "Salvar valores",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: temaPadrao.primaryColor,
                      elevation: 5,
                      padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {
                        _validarCampos();
                      }),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Center(
                    child: Text(
                      _mensagemErro,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 15
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 6),
                  child: Center(
                    child: Text(
                      _mensagem,
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 15
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
