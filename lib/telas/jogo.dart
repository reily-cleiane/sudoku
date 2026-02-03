import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/grid.dart';
import 'package:sudoku_app/componentes/teclado.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/logica/logica.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/posicao.model.dart';

class Jogo extends StatefulWidget {
  //Recebe key (que é padrão do framework, título, e dificuldade do jogo)
  const Jogo({super.key, required this.titulo, required this.dificuldade});
  final String titulo;
  final Dificuldade dificuldade;

  @override
  JogoState createState() => JogoState();
}

class JogoState extends State<Jogo> {
  List<List<Celula>> tabuleiro = [];
  (int, int)? posicaoSelecionada;
  Posicao? posicaoDestacadaDuplicidade;
  List<int> contagemNumeros = [];

  @override
  void initState() {
    super.initState();
    tabuleiro = LogicaSudoku.gerarTabuleiro(widget.dificuldade);
    contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
  }

  void _inserirNumero(int valor) {
    if (posicaoSelecionada == null || tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].isFixo) {
      return;
    }

    final (sucesso, jogadaInvalida) = LogicaSudoku.inserirNumero(tabuleiro, valor, posicaoSelecionada);

    if (sucesso) {
      setState(() {
        contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
        posicaoDestacadaDuplicidade = null;
      });
      return;
    }

    if (jogadaInvalida?.repeteNaLinha == true && jogadaInvalida?.posicaoDuplicadaNaLinha != null) {
      setState(() {
        posicaoDestacadaDuplicidade = jogadaInvalida!.posicaoDuplicadaNaLinha;
      });
      return;
    }

    if (jogadaInvalida?.repeteNaColuna == true && jogadaInvalida?.posicaoDuplicadaNaColuna != null) {
      setState(() {
        posicaoDestacadaDuplicidade = jogadaInvalida!.posicaoDuplicadaNaColuna;
      });
      return;
    }

    if (jogadaInvalida?.repeteNoBloco == true && jogadaInvalida?.posicaoDuplicadaNoBloco != null) {
      setState(() {
        posicaoDestacadaDuplicidade = jogadaInvalida!.posicaoDuplicadaNoBloco;
      });
      return;
    }
  }

  void _celulaClicada(Posicao posicao) {
    posicaoSelecionada = posicao;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.asset("imagens/bg.jpg", fit: BoxFit.cover)),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(title: const Text("Sudoku"), centerTitle: true, backgroundColor: Colors.purple),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: GridSudoku(
                        tabuleiro: tabuleiro,
                        celulaClicada: (posicao) => _celulaClicada(posicao),
                        posicaoDestacadaDuplicidade: posicaoDestacadaDuplicidade,
                      ),
                    ),
                  ),
                ),
                Teclado(
                  valoresDisponiveis: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                  inserirNumero: (valor) => _inserirNumero(valor),
                  contagemNumeros: contagemNumeros,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
