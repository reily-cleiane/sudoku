import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/celula.dart';
import 'package:sudoku_app/estilo.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/posicao.model.dart';

class GridSudoku extends StatefulWidget {
  const GridSudoku({
    super.key,
    required this.tabuleiro,
    required this.eventoCelulaClicada,
    this.posicaoErroDuplicidade,
  });
  final List<List<Celula>> tabuleiro;
  final Function(Posicao posicao) eventoCelulaClicada;
  final Posicao? posicaoErroDuplicidade;

  @override
  State<GridSudoku> createState() => _GridSudokuState();
}

class _GridSudokuState extends State<GridSudoku> {
  bool _alternadorGatilho = false;
  Posicao? _posicaoSelecionada;

  void _tratarToque(int i, int j) {
    setState(() {
      _posicaoSelecionada = (i, j);
    });
    widget.eventoCelulaClicada((i, j));
  }

  @override
  void didUpdateWidget(GridSudoku oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Se o pai enviou QUALQUER posição de erro
    if (widget.posicaoErroDuplicidade != null) {
      setState(() {
        _alternadorGatilho = !_alternadorGatilho; // Inverte o bit
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int? valorSelecionado;
    if (_posicaoSelecionada != null) {
      valorSelecionado = widget.tabuleiro[_posicaoSelecionada!.$1][_posicaoSelecionada!.$2].valor;
    }

    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          //border: Border.all(width: 2),
          image: DecorationImage(image: AssetImage("imagens/grid.png"), fit: BoxFit.cover),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(3, 6, 3, 1),
          child: GridView.builder(
            // Usar builder é mais performático que GridView.count para grids dinâmicos
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9),
            itemCount: 81,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              int i = index ~/ 9;
              int j = index % 9;

              bool estaSelecionada = _posicaoSelecionada?.$1 == i && _posicaoSelecionada?.$2 == j;
              bool mesmaLinhaOuColuna =
                  _posicaoSelecionada != null && (i == _posicaoSelecionada!.$1 || j == _posicaoSelecionada!.$2);
              bool devePiscar = widget.posicaoErroDuplicidade?.$1 == i && widget.posicaoErroDuplicidade?.$2 == j;

              return GestureDetector(
                onTap: () => _tratarToque(i, j),
                child: CelulaGrid(
                  celula: widget.tabuleiro[i][j],
                  estaSelecionada: estaSelecionada,
                  celulaEstaNaMesmaLinhaOuColuna: mesmaLinhaOuColuna,
                  valorSelecionado: valorSelecionado,
                  devePiscar: devePiscar,
                  gatilho: _alternadorGatilho,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
