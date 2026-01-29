import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sudoku_app/modelos/celula.model.dart';

class Grid extends StatelessWidget{
  const Grid({super.key, required this.valores, required this.celulaClicada});
  final List<Celula> valores;
  final Function(int index) celulaClicada;

  Widget _formatarConteudoCelula(Celula celula){

    if(celula.eFixo){
      return Center(child:
        Text(
        celula.valor?.toString() ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ));
    }else if(celula.valor == null && celula.rascunho.isNotEmpty) {
      final maiorNumeroPossivel = sqrt(valores.length);
      List<Text> numeros = [];

      for(int i = 1; i <= maiorNumeroPossivel; i++){
        final existeNoRascunho = celula.rascunho.contains(i);
        final conteudo = existeNoRascunho? '$i ': ' ';
        numeros.add(Text(conteudo, style: const TextStyle(fontSize: 8)));
      }
      return Wrap(
        children: numeros,
      );
    }else {
      return Center(child:
        Text(
        celula.valor?.toString() ?? '',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color.fromARGB(255, 50, 114, 211),
        ),
      ));
    }
  }
  
  List<Widget> gerarCelulas(){
    List<Widget> celulas = [];
    for(int i = 0; i < valores.length; i++){

      final celula = 
      GestureDetector(
        onTap: () => celulaClicada(i),
        child:
        Container(
          //decoration: BoxDecoration(
            //color: Colors.amber[100], 
            //border: Border.all(width: 0)),
          margin: const EdgeInsets.all(0),
          child: _formatarConteudoCelula(valores[i])
        ));
      celulas.add(celula);
    }
    return celulas;
  }

   @override
   Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.0,
        child: Container(
          decoration: BoxDecoration(
            //border: Border.all(width: 2), 
            image: DecorationImage(
            image: AssetImage("imagens/grid.png"),
            fit: BoxFit.cover,
            ),),
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 9,
            physics: const NeverScrollableScrollPhysics(),
            children: gerarCelulas()
          )
        )
      );
   }
}