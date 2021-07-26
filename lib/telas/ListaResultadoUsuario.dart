import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_quest_adm/model/UsuarioModel.dart';
import '../main.dart';
import 'ItemUsuarios.dart';

class ListaResultadoUsuario extends StatefulWidget {
  @override
  _ListaResultadoUsuarioState createState() => _ListaResultadoUsuarioState();
}

class _ListaResultadoUsuarioState extends State<ListaResultadoUsuario> {

  final _controller = StreamController<QuerySnapshot>.broadcast();

  Future<Stream<QuerySnapshot>> _adicionarListenerUsuarios()async{

    Firestore db = Firestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("usuarios")
        .where("status",isEqualTo: "liberado")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerUsuarios();
  }

  var carregandoDados = Center(
    child: Column(children: <Widget>[
      Container(child: Text("Carregando usuários")),
      CircularProgressIndicator()
    ],),
  );

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
          alignment: Alignment.center,
          padding: EdgeInsets.all(25),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Resultados",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor,
                        fontWeight:FontWeight.bold,
                      )
                  ),
                ],
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _controller.stream,
                  builder: (context,snapshot){

                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return carregandoDados;
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:

                        if(snapshot.hasError)
                          return Text("Erro ao carregar dados!");

                        QuerySnapshot querySnapshot = snapshot.data;
                        return ListView.builder(
                            itemCount: querySnapshot.documents.length,
                            itemBuilder: (_,indice){

                              List<DocumentSnapshot> perguntas = querySnapshot.documents.toList();
                              DocumentSnapshot documentSnapshot = perguntas[indice];
                              UsuarioModel usuario = UsuarioModel.fromDocumentSnapshot(documentSnapshot);

                              return ItemUsuarios(
                                usuarioModel: usuario,
                                onTapItem: (){
                                  Navigator.pushNamed(
                                      context,
                                      "/resultados",
                                      arguments: usuario
                                  );
                                },
                              );
                            }
                        );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          )
      ),
    );
  }
}
