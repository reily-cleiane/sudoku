import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/celula.dart';
import 'package:sudoku_app/modelos/celula.model.dart';

class Grid extends StatelessWidget {
  const Grid({super.key, required this.tabuleiro, required this.celulaClicada});
  final List<List<Celula>> tabuleiro;
  final Function(int index) celulaClicada;

  List<Widget> gerarCelulas() {
    List<Widget> celulas = [];
    for (int i = 0; i < tabuleiro.length; i++) {
      for (int j = 0; j < tabuleiro.length; j++) {
        final celula = GestureDetector(
          onTap: () => celulaClicada(i),
          child: Container(
            //decoration: BoxDecoration(
            //color: Colors.amber[100],
            //border: Border.all(width: 0)),
            margin: const EdgeInsets.all(0),
            child: CelulaGrid(celula: tabuleiro[i][j]),
          ),
        );
        celulas.add(celula);
      }
    }
    return celulas;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 5, 3, 1),
        decoration: BoxDecoration(
          //border: Border.all(width: 2),
          image: DecorationImage(
            image: AssetImage("imagens/grid.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          children: gerarCelulas(),
        ),
      ),
    );
  }
}
