import 'package:flutter/material.dart';
import 'package:todo_list/model/afazer.dart';
import 'package:todo_list/util/db_ajudante.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class AfazeresTela extends StatefulWidget {
  @override
  _AfazeresTelaState createState() => _AfazeresTelaState();
}

class _AfazeresTelaState extends State<AfazeresTela> {
  final TextEditingController _controller = new TextEditingController();
  var db = new DbAjudante();
  final List<Afazer> _afazerLista = <Afazer>[];

  @override
  void initState() {
    super.initState();
    _pegarAfazeres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Column(
        children: [
          Flexible(
              child: ListView.builder(
                  itemCount: _afazerLista.length,
                  padding: const EdgeInsets.all(8.0),
                  itemBuilder: (_, int posicao) {
                    return Card(
                      color: Colors.black54,
                      child: ListTile(
                        title: _afazerLista[posicao],
                        onLongPress: () =>
                            _atualizarAfazer(_afazerLista[posicao], posicao),
                        trailing: Listener(
                          key: Key(_afazerLista[posicao].afazerNome),
                          child: Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                          ),
                          onPointerDown: (pointerEvento) =>
                              _apagarAfazer(_afazerLista[posicao].id, posicao),
                        ), //Clique longo
                      ),
                    );
                  }))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _mostraFormulario,
      ),
    );
  }

  void _pegarAfazeres() async {
    List afazeres = await db.recuperarTodosAfazeres();
    afazeres.forEach((item) {
      setState(() {
        _afazerLista.add(Afazer.map(item));
      });
    });
  }

  void _mostraFormulario() {
    var alert = AlertDialog(
      content: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            // Ao acessar o formulario ativa automaticamente o campo de texto para digitação
            autofocus: true,
            decoration: InputDecoration(
                labelText: 'Tarefa',
                hintText: 'Digite...',
                icon: Icon(Icons.note_add)),
          ))
        ],
      ),
      actions: [
        FlatButton(
            onPressed: () {
              _lidarComTexto(_controller.text);
              _controller.clear();
              Navigator.pop(context);
            },
            child: Text('Salvar'))
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _lidarComTexto(String text) async {
    _controller.clear();
    Afazer afazer = new Afazer(text, dataFormatada(), dataFormatada());
    int salvoId = await db.salvarAfazer(afazer);

    Afazer itemSalvo = await db.recuperarAfazer(salvoId);
    setState(() {
      _afazerLista.insert(0, itemSalvo);
    });
  }

  _atualizarAfazer(Afazer afazer, int posicao) {
    var alert = AlertDialog(
      title: Text("Atualizar Afazer"),
      content: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _controller,
            autofocus: true,
            decoration:
                InputDecoration(labelText: "Afazer", icon: Icon(Icons.update)),
          ))
        ],
      ),
      actions: [
        FlatButton(
            onPressed: () async {
              Afazer atualizarItem = Afazer.fromMap({
                "nome": _controller.text,
                "data": afazer.afazerDataCriando,
                "finalizar": dataFormatada(),
                "id": afazer.id
              });

              _lidarComAtualizacao(posicao, afazer);
              await db.atualizarAfazer(atualizarItem);
              setState(() {
                _pegarAfazeres();
                Navigator.pop(context);
              });
            },
            child: Text('Atualizar')),
        FlatButton(
            onPressed: () => Navigator.pop(context), child: Text("Cancelar")),
      ],
    );
    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  void _lidarComAtualizacao(posicao, Afazer afazer) {

    setState(() {
      _afazerLista.removeWhere((element) {
        _afazerLista[posicao].afazerNome == afazer.afazerNome;
      });
    });
    _controller.clear();
  }

  _apagarAfazer(int id, int posicao) async {
    await db.apagarAfazer(id);
    setState(() {
      _afazerLista.removeAt(posicao);
    });
  }
}

String dataFormatada() {
  var agora = DateTime.now();

  initializeDateFormatting("pt_BR", null);
  var format = new DateFormat.yMMMMd("pt_BR");

  return format.format(agora);
}
