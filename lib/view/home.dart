import 'package:flutter/material.dart';
import 'package:todo_list/view/afazeres_tela.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("TODO List"),
        backgroundColor: Colors.black87,
      ),
      body: AfazeresTela(),
    );
  }
}
