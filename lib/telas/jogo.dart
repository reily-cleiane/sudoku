import 'package:flutter/material.dart';
import 'dart:developer';
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

  @override
  void initState() {
    super.initState();
    tabuleiro = LogicaSudoku.gerarTabuleiro(widget.dificuldade);
  }

  void _inserirNumero(int valor) {
    final (sucesso, jogadaInvalida) = LogicaSudoku.inserirNumero(tabuleiro, valor, posicaoSelecionada);
    if (sucesso) {
      setState(() {});
    } else {
      print("Jogada inválida!");
    }
  }

  void _celulaSelecionada(Posicao posicao) {
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
                        celulaSelecionada: (posicao) => _celulaSelecionada(posicao),
                      ),
                    ),
                  ),
                ),
                Teclado(
                  valoresDisponiveis: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                  inserirNumero: (valor) => _inserirNumero(valor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
