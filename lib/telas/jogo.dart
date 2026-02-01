import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:sudoku_app/componentes/grid.dart';
import 'package:sudoku_app/componentes/teclado.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/logica/logica.dart';
import 'package:sudoku_app/modelos/celula.model.dart';

class Jogo extends StatefulWidget{
  //Recebe key (que é padrão do framework, título, e dificuldade do jogo)
  const Jogo({super.key, required this.titulo, required this.dificuldade});
  final String titulo;
  final Dificuldade dificuldade;
  
  @override
  JogoState createState() => JogoState();
    
}
class JogoState extends State<Jogo> {
  List<List<Celula>> tabuleiro = [];

  @override
  void initState() {
    super.initState();
    tabuleiro = LogicaSudoku.gerarTabuleiro(widget.dificuldade);
  }

  void _celulaClicada(int valor){
    log("celula clicada indice $valor");
  }

  @override
  Widget build(BuildContext context) {
    return Stack( 
      children: [

        Positioned.fill( 
          child: Image.asset(
            "imagens/bg.jpg", 
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, 
          appBar: AppBar(
            title: const Text("Sudoku"),
            centerTitle: true,
            backgroundColor: Colors.purple, 
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: Grid(
                        tabuleiro: tabuleiro,
                        celulaClicada: (valor) => _celulaClicada(valor),
                      ),
                    ),
                  ),
                ),
                Teclado(
                  valoresDisponiveis: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                  botaoClicado: (valor) => _celulaClicada(valor),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

}