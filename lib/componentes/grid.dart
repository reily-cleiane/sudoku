import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/celula.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/posicao.model.dart';

class GridSudoku extends StatefulWidget {
  const GridSudoku({super.key, required this.tabuleiro, required this.celulaClicada, this.posicaoDestacadaDuplicidade});
  final List<List<Celula>> tabuleiro;
  final Function(Posicao posicao) celulaClicada;
  final Posicao? posicaoDestacadaDuplicidade;

  @override
  State<GridSudoku> createState() => _GridSudokuState();
}

class _GridSudokuState extends State<GridSudoku> with SingleTickerProviderStateMixin {
  Posicao? _celulaLocalDestacada;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  Posicao? _posicaoInternaPiscar;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: Colors.red.withValues(alpha: 0.2),
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        // Limpar o estado para não ficar sempre em estado de piscando
        setState(() {
          _posicaoInternaPiscar = null;
        });
      }
    });
  }

  @override
  void dispose() {
    // Liberar memória
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GridSudoku oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.posicaoDestacadaDuplicidade != null) {
      setState(() {
        _posicaoInternaPiscar = widget.posicaoDestacadaDuplicidade;
      });
      _controller.forward(from: 0.0); // Reinicia a animação do zero, para poder animar novamente em caso de novo erro
    }
  }

  void _tratarToque(int i, int j) {
    setState(() {
      _celulaLocalDestacada = (i, j);
    });
    widget.celulaClicada((i, j));
  }

  List<Widget> gerarCelulas() {
    List<Widget> celulas = [];
    for (int i = 0; i < widget.tabuleiro.length; i++) {
      for (int j = 0; j < widget.tabuleiro.length; j++) {
        // Isso aqui é para fazer o builder rodar quando a animação rodar
        // se não, a animação dispara, mas o builder não vai mostrar
        final celulaWidget = AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            final bool isPiscando = _posicaoInternaPiscar?.$1 == i && _posicaoInternaPiscar?.$2 == j;

            return GestureDetector(
              onTap: () => _tratarToque(i, j),
              child: Container(
                decoration: BoxDecoration(
                  color: isPiscando
                      ? _colorAnimation
                            .value // Agora ele vai pegar o valor atualizado no tempo
                      : (_celulaLocalDestacada?.$1 == i && _celulaLocalDestacada?.$2 == j)
                      ? const Color.fromARGB(92, 199, 155, 106)
                      : Colors.transparent,
                ),
                child: CelulaGrid(celula: widget.tabuleiro[i][j]),
              ),
            );
          },
        );
        celulas.add(celulaWidget);
      }
    }
    return celulas;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(3, 7, 3, 1),
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
