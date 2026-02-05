import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/grid.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/telas/jogo.dart';
import 'dart:developer';

class NovoJogo extends StatefulWidget {
  const NovoJogo({super.key, required this.title});

  final String title;

  @override
  _NovoJogoState createState() => _NovoJogoState();
}

class _NovoJogoState extends State<NovoJogo> {
  void iniciarJogo(Dificuldade dificuldade) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        //builder: (context) => Grid())
        builder: (context) => Jogo(dificuldade: dificuldade),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sudoku"), centerTitle: true, backgroundColor: Colors.purple),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: () {
                  iniciarJogo(DificuldadeFacil());
                },
                child: const Text('Fácil', style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0)),

            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: () {
                  iniciarJogo(DificuldadeMedia());
                },
                child: const Text('Médio', style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
            ),
            Padding(padding: const EdgeInsets.fromLTRB(0, 30.0, 0, 0)),

            SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: () {
                  iniciarJogo(DificuldadeDificil());
                },
                child: const Text('Difícil', style: TextStyle(color: Colors.black, fontSize: 20.0)),
              ),
            ),
          ],
        ),
      ),
    );
  } // Fim do build
}
