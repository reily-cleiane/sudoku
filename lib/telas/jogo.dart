import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:sudoku_app/componentes/grid.dart';
import 'package:sudoku_app/componentes/teclado.dart';
import 'package:sudoku_app/modelos/celula.model.dart';

class Jogo extends StatefulWidget{
  const Jogo({super.key, required this.title});
  final String title;
  

  @override
  _JogoState createState() => _JogoState();
    
}
class _JogoState extends State<Jogo> {

  List<Celula> _gerarGridMockado(){

    List<Celula> lista = List.generate(81, (index) =>Celula());

    for(int i = 0; i < 81; i++){
      if(i % 5 == 0){
        lista[i].valor = 5;
        lista[i].eFixo = true;
      }
      else if(i % 8 == 0){
        lista[i].valor = 8;
      }
    }
    return lista;

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
                        valores: _gerarGridMockado(),
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