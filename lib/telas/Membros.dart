import 'package:flutter/material.dart';
import '../main.dart';
import 'UsuariosLiberados.dart';
import 'UsuariosPendentes.dart';
import 'UsuariosRejeitados.dart';

class Membros extends StatefulWidget {

  @override
  _MembrosState createState() => _MembrosState();
}

class _MembrosState extends State<Membros> {
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 5),
                child: Text("Usuários",
                    style: TextStyle(fontSize: 25,
                        color: temaPadrao.primaryColor,fontWeight:FontWeight.bold)),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6),
                child: RaisedButton(
                    child: Text(
                      "Pendentes de liberação",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsuariosPendentes()
                          )
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: RaisedButton(
                    child: Text(
                      "Liberados",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsuariosLiberados()
                          )
                      );
                    }),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: RaisedButton(
                    child: Text(
                      "Rejeitados",
                      style: TextStyle(color: temaPadrao.accentColor, fontSize: 20),
                    ),
                    color: temaPadrao.secondaryHeaderColor,
                    elevation: 5,
                    padding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UsuariosRejeitados()
                          )
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
