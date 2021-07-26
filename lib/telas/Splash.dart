import 'package:flutter/material.dart';
import 'package:med_quest_adm/telas/Login.dart';
import '../main.dart';

class Splash extends StatefulWidget {

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Future<bool> _mockCheckForSession()async{
    await Future.delayed(Duration(milliseconds: 5000),(){});

    return true;
  }

  @override
  void initState() {
    super.initState();

    _mockCheckForSession().then(
            (status) {

          if(status){
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: ( BuildContext context) => Login()
                )
            );
          }
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: temaPadrao.accentColor,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Image.asset(
                        "assets/imagens/logoOficial.png",
                        width: 350,
                        height: 200,
                      )
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(color: Colors.white),

                )
              ],
            ),
          )
      ),
    );
  }
}
