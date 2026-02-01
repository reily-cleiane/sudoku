import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sudoku_app/modelos/celula.model.dart';

class CelulaGrid extends StatelessWidget {
  const CelulaGrid({super.key, required this.celula});

  final Celula celula;

  Padding _recuperarNumero(Celula celula, [bool fixo = false]) {
    String nome = fixo ? "${celula.valor}.png" : "${celula.valor}a.png)";
    String caminho = "imagens/imgs_celulas/$nome";
    return Padding(
      padding: EdgeInsetsGeometry.all(10),
      child: Image.asset(caminho),
    );
  }

  Wrap _gerarCelulaRascunho(Celula celula) {
    final maiorNumeroPossivel = 9;
    List<Text> numeros = [];

    for (int i = 1; i <= maiorNumeroPossivel; i++) {
      final existeNoRascunho = celula.rascunho.contains(i);
      final conteudo = existeNoRascunho ? '$i ' : ' ';
      numeros.add(Text(conteudo, style: const TextStyle(fontSize: 8)));
    }
    return Wrap(children: numeros);
  }

  Center _gerarCelulaFixa(Celula celula) {
    return Center(child: _recuperarNumero(celula, true));
    // return Center(
    //   child: Text(
    //     celula.valor?.toString() ?? '',
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //       color: Colors.black,
    //     ),
    //   ),
    // );
  }

  Center _gerarCelulaPreenchida(Celula celula) {
    return Center(child: _recuperarNumero(celula, false));
    // return Center(
    //   child: Text(
    //     celula.valor?.toString() ?? '',
    //     style: TextStyle(
    //       fontSize: 20,
    //       fontWeight: FontWeight.bold,
    //       color: const Color.fromARGB(255, 50, 114, 211),
    //     ),
    //   ),
    // );
  }

  Widget _gerarCelula(Celula celula) {
    if (celula.isFixo) {
      return _gerarCelulaFixa(celula);
    } else if ((celula.valor == 0 || celula.valor == null) &&
        celula.rascunho.isNotEmpty) {
      return _gerarCelulaRascunho(celula);
    } else if (celula.valor == 0 || celula.valor == null) {
      return Text('');
    } else {
      return _gerarCelulaPreenchida(celula);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _gerarCelula(celula);
  }
}
