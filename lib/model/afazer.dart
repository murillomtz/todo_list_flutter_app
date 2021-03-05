import 'package:flutter/material.dart';

class Afazer extends StatelessWidget {
  String _afazerNome;
  String _afazerDataCriando;
  String _afazerDataFinalizacao;
  int _id;

  Afazer(
      this._afazerNome, this._afazerDataCriando, this._afazerDataFinalizacao);

  Afazer.map(dynamic obj) {
    this._afazerNome = obj['nome'];
    this._afazerDataCriando = obj['data'];
    this._afazerDataFinalizacao = obj['finalizar'];
    this._id = obj['id'];
  }

  String get afazerNome => _afazerNome;

  String get afazerDataCriando => _afazerDataCriando;

  String get afazerDataFinalizacao => _afazerDataFinalizacao;

  int get id => _id;

  Map<String, dynamic> toMap() {
    var mapa = new Map<String, dynamic>();
    mapa["nome"] = _afazerNome;
    mapa["data"] = _afazerDataCriando;
    mapa["finalizar"] = _afazerDataFinalizacao;

    if (_id != null) {
      mapa["id"] = _id;
    }

    return mapa;
  }

  Afazer.fromMap(Map<String, dynamic> mapa) {
    this._afazerNome = mapa["nome"];
    this._afazerDataCriando = mapa["data"];
    this._afazerDataFinalizacao = mapa["finalizar"];
    this._id = mapa["id"];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _afazerNome,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.9),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(
                "$afazerDataCriando",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    fontStyle: FontStyle.italic),
              ),
            ),
          )
        ],
      ),
    );
  }
}
