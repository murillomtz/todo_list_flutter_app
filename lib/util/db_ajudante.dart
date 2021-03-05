import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'dart:async';

import 'package:todo_list/model/afazer.dart';

class DbAjudante {
  static final DbAjudante _instance = new DbAjudante.internal();

  factory DbAjudante() => _instance;

  final String nomeTabela = "afazeresTabela";
  final String colunaId = "id";
  final String afazeresNome = "nome";
  final String afazeresDataCriado = "data";
  final String _afazerDataFinalizacao = "finalizar";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  DbAjudante.internal();

  initDb() async {
    Directory documentoDiretorio = await getApplicationDocumentsDirectory();
    String path = join(documentoDiretorio.path, "afazeres_db.db");
    var nossaDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return nossaDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $nomeTabela($colunaId INTEGER PRIMARY KEY,"
        "$afazeresNome TEXT,"
        "$afazeresDataCriado TEXT,"
        "$_afazerDataFinalizacao TEXT)");
  }

  Future<int> salvarAfazer(Afazer item) async {
    var dbCliente = await db;

    int res = await dbCliente.insert("$nomeTabela", item.toMap());

    print(res.toString());

    return res;
  }

  Future<List> recuperarTodosAfazeres() async {
    var dbCliente = await db;

    var res = await dbCliente
        .rawQuery("SELECT * FROM $nomeTabela ORDER BY $afazeresDataCriado");

    print(res.toString());
    return res.toList();
  }

  Future<int> contagem() async {
    var dbCliente = await db;

    return Sqflite.firstIntValue(
        await dbCliente.rawQuery("SELECT COUNT(*) FROM $nomeTabela"));
  }

  Future<Afazer> recuperarAfazer(int id) async {
    var dbCliente = await db;

    var res = await dbCliente
        .rawQuery("SELECT * FROM $nomeTabela WHERE $colunaId = $id");

    if (res.length == 0) {
      return null;
    } else {
      return new Afazer.fromMap(res.first);
    }
  }

  Future<int> apagarAfazer(int id) async {
    var bdCliente = await db;

    return await bdCliente
        .delete(nomeTabela, where: "$colunaId = ?", whereArgs: [id]);
  }

  Future<int> atualizarAfazer(Afazer item) async {
    var bdCliente = await db;
    return await bdCliente.update("$nomeTabela", item.toMap(),
        where: "$colunaId = ?", whereArgs: [item.id]);
  }

  Future fechar() async {
    var bdCliente = await db;
    return bdCliente.close();
  }
}
