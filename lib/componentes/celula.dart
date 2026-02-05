import 'package:flutter/material.dart';
import 'dart:math';
import 'package:sudoku_app/modelos/celula.model.dart';

/**
 * Classe responsável por gerar o conteúdo formatado de uma célula do grid
 */
class CelulaGrid extends StatelessWidget {
  const CelulaGrid({super.key, required this.celula});

  final Celula celula;

  // Recupera a imagem correta a ser exibida na célula, de acordo com o valor desejado
  Padding _recuperarNumero(Celula celula, [bool fixo = false]) {
    String nome = fixo ? "${celula.valor}.png" : "${celula.valor}a.png";
    String caminho = "imagens/imgs_celulas/$nome";
    return Padding(padding: EdgeInsetsGeometry.all(10), child: Image.asset(caminho));
  }

  Padding _gerarCelulaRascunho(Celula celula) {
    final maiorNumeroPossivel = 9;
    List<Text> numeros = [];

    for (int i = 1; i <= maiorNumeroPossivel; i++) {
      final existeNoRascunho = celula.rascunho.contains(i);
      final conteudo = existeNoRascunho ? '$i ' : ' ';
      numeros.add(Text(conteudo, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10)));
    }
    return Padding(
      padding: EdgeInsetsGeometry.all(2),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        children: numeros,
      ),
    );
  }

  Center _gerarCelulaFixa(Celula celula) {
    return Center(child: _recuperarNumero(celula, true));
  }

  Center _gerarCelulaPreenchida(Celula celula) {
    return Center(child: _recuperarNumero(celula, false));
  }

  Widget _gerarCelula(Celula celula) {
    if (celula.isFixo) {
      return _gerarCelulaFixa(celula);
    } else if ((celula.valor == 0 || celula.valor == null) && celula.rascunho.isNotEmpty) {
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
