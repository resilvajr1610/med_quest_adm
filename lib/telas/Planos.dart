import 'package:brasil_fields/formatter/real_input_formatter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_quest_adm/model/PlanoModel.dart';
import '../main.dart';

class Planos extends StatefulWidget {

  @override
  _PlanosState createState() => _PlanosState();
}

class _PlanosState extends State<Planos> {

  TextEditingController _controllerMensal = TextEditingController();
  TextEditingController _controllerTrimestral = TextEditingController();
  TextEditingController _controllerAnual = TextEditingController();
  PlanoModel _planoModel = PlanoModel();
  String _mensal;
  String _trimestral;
  String _anual;
  String _mensagemErro = "";
  String _mensagem = "";

  @override
  void initState() {
    super.initState();
    _recuperarDadosPlanos();
    _planoModel = PlanoModel.gerarId();
  }

  _recuperarDadosPlanos()async{

    Firestore db = Firestore.instance;
    DocumentSnapshot snapshot = await
        db.collection("planos")
        .document("planos")
        .get();

    Map<String,dynamic> dados = snapshot.data;
    setState(() {
      _mensagemErro = "";
      _mensal = dados["mensal"].toString();
      _anual = dados["anual"].toString();
      _trimestral =dados["trimestral"].toString();
      _mensal = _mensal.replaceAll(".", ",");
      _controllerMensal = TextEditingController(text: _mensal);
      _trimestral = _trimestral.replaceAll(".", ",");
      _controllerTrimestral = TextEditingController(text: _trimestral);
      _anual = _anual.replaceAll(".", ",");
      _controllerAnual = TextEditingController(text: _anual);
    });
  }

  _salvar(){
    //salvar firebase
    String moedaMensal = _controllerMensal.text.toString();
    moedaMensal = moedaMensal.replaceAll(".", "");
    moedaMensal = moedaMensal.replaceAll(",", ".");

    String moedaTrimestral = _controllerTrimestral.text.toString();
    moedaTrimestral = moedaTrimestral.replaceAll(".", "");
    moedaTrimestral = moedaTrimestral.replaceAll(",", ".");

    String moedaAnual = _controllerAnual.text.toString();
    moedaAnual = moedaAnual.replaceAll(".", "");
    moedaAnual = moedaAnual.replaceAll(",", ".");

    _planoModel.mensal = moedaMensal;
    _planoModel.trimestral = moedaTrimestral;
    _planoModel.anual = moedaAnual;

    Firestore db = Firestore.instance;
    db.collection("planos")
        .document("planos")
        .setData(_planoModel.toMap()).then((_) {

      setState(() {
        _mensagem = "Valores salvos com sucesso!";
      });

    });
  }

  _validarCampos() {
    //recuperar dados dos campos
    _mensal = _controllerMensal.text;
    _trimestral = _controllerTrimestral.text;
    _anual = _controllerAnual.text;

    if (_mensal.isNotEmpty) {
      if (_trimestral.isNotEmpty) {
        if(_anual.isNotEmpty){
          setState(() {
            _mensagemErro = "";
            _mensal = "";
            _trimestral = "";
            _anual = "";
          });
            _salvar();
        }else{
          setState(() {
            _mensagemErro = "Preencha o valor anual";
          });
        }
      } else {
        setState(() {
          _mensagemErro = "Preencha o valor trimestral";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o valor mensal";
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
              child: Text("Planos",
                  style: TextStyle(fontSize: 25,
                      color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
            ),
            Padding(
                padding:EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Text( "Mensal",
                  style: TextStyle(color: temaPadrao.accentColor, fontSize: 20)),
                ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 90,left: 90),
              child: TextField(
                  controller: _controllerMensal,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
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
                child: Text( "Trimestral",
                    style: TextStyle(color: temaPadrao.accentColor, fontSize: 20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 90,left: 90),
              child: TextField(
                  controller: _controllerTrimestral,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
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
                child: Text( "Anual",
                    style: TextStyle(color: temaPadrao.accentColor, fontSize: 20)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 90,left: 90),
              child: TextField(
                  controller: _controllerAnual,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    RealInputFormatter(centavos: true)
                  ],
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
            ),Padding(
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
