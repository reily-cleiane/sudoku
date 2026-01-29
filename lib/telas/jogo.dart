import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:sudoku_app/componentes/grid.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Sudoku"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ), 
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child:  Padding(padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: AspectRatio(aspectRatio: 1.0,
              child: Grid(valores:_gerarGridMockado(), celulaClicada: (valor) => _celulaClicada(valor)),
              ) ),
            ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(9, (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaçamento entre botões
                child: AspectRatio(
                  aspectRatio: 1, // Mantém o botão quadrado
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.purple.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () => log("Número selecionado: ${index + 1}"),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )));
          
          }))]))
            
        );
      
   }

}