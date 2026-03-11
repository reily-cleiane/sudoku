import 'package:flutter/material.dart';
import 'package:sudoku/componentes/celula.dart';
import 'package:sudoku/modelos/celula.model.dart';
import 'package:sudoku/modelos/posicao.model.dart';

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

    // SÓ inverte o gatilho se a posição de erro MUDOU em relação ao estado anterior
    // ou se não havia erro e agora há.
    if (widget.posicaoErroDuplicidade != null && widget.posicaoErroDuplicidade != oldWidget.posicaoErroDuplicidade) {
      setState(() {
        _alternadorGatilho = !_alternadorGatilho;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const porcentagemBordaLateral = 12.69531 / 100;
    const porcentagemBordaTopo = 10.64453 / 100;
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
          padding: EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width * porcentagemBordaLateral,
            MediaQuery.of(context).size.width * porcentagemBordaTopo,
            MediaQuery.of(context).size.width * porcentagemBordaLateral,
            0,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            primary: false,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 9, childAspectRatio: 0.94),
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
