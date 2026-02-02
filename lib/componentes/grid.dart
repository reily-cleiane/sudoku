import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/celula.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/posicao.model.dart';

class GridSudoku extends StatefulWidget {
  const GridSudoku({super.key, required this.tabuleiro, required this.celulaSelecionada});
  final List<List<Celula>> tabuleiro;
  final Function(Posicao posicao) celulaSelecionada;

  @override
  State<GridSudoku> createState() => _GridSudokuState();
}

class _GridSudokuState extends State<GridSudoku> {
  Posicao? _celulaLocalDestacada;
  List<List<Celula>> tabuleiro = [];

  @override
  void initState() {
    super.initState();
    tabuleiro = widget.tabuleiro;
  }

  void _tratarToque(int i, int j) {
    setState(() {
      _celulaLocalDestacada = (i, j);
    });
    widget.celulaSelecionada((i, j));
  }

  List<Widget> gerarCelulas() {
    List<Widget> celulas = [];
    for (int i = 0; i < tabuleiro.length; i++) {
      for (int j = 0; j < tabuleiro.length; j++) {
        final celula = GestureDetector(
          onTap: () => _tratarToque(i, j),
          child: Container(
            decoration: BoxDecoration(
              color: (_celulaLocalDestacada != null && _celulaLocalDestacada?.$1 == i && _celulaLocalDestacada?.$2 == j)
                  ? const Color.fromARGB(118, 107, 81, 4)
                  : const Color.fromARGB(0, 0, 0, 0),
            ),
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
          image: DecorationImage(image: AssetImage("imagens/grid.png"), fit: BoxFit.cover),
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
