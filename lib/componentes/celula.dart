import 'package:flutter/material.dart';
import 'package:sudoku_app/estilo.dart';
import 'package:sudoku_app/modelos/celula.model.dart';

/// Classe responsável por gerar o conteúdo formatado de uma célula do grid
class CelulaGrid extends StatelessWidget {
  const CelulaGrid({super.key, required this.celula, this.valorSelecionado, this.celulaEstaSelecionada = false});
  final Celula celula;
  final int? valorSelecionado;
  final bool? celulaEstaSelecionada;

  bool get _deveDestacarValorSelecionado =>
      valorSelecionado != null && celula.valor != 0 && celula.valor == valorSelecionado;

  Color get _corDestaqueValorSelecionado => Estilo.corDestaqueBackgroundValorSelecionado;
  Color get _corDestaqueLinhaColuna => Estilo.corDestaqueBackgroundLinhaColuna;

  /// Recupera a imagem correta a ser exibida na célula, de acordo com o valor desejado
  Padding _recuperarNumero(Celula celula, [bool fixo = false]) {
    String nome = fixo ? "${celula.valor}.png" : "${celula.valor}a.png";
    String caminho = "imagens/imgs_celulas/$nome";
    return Padding(padding: const EdgeInsets.all(10), child: Image.asset(caminho));
  }

  Padding _gerarCelulaRascunho(Celula celula) {
    final maiorNumeroPossivel = 9;
    List<Text> numeros = [];

    for (int i = 1; i <= maiorNumeroPossivel; i++) {
      final existeNoRascunho = celula.rascunho.contains(i);
      final conteudo = existeNoRascunho ? '$i ' : ' ';
      final destacarValorEmRascunho = valorSelecionado == i;
      numeros.add(
        Text(
          conteudo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            backgroundColor: destacarValorEmRascunho ? _corDestaqueValorSelecionado : null,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.0,
        children: numeros,
      ),
    );
  }

  Container _gerarCelulaFixa(Celula celula) {
    return Container(
      color: _deveDestacarValorSelecionado ? _corDestaqueValorSelecionado : null,
      child: Center(child: _recuperarNumero(celula, true)),
    );
  }

  Container _gerarCelulaPreenchida(Celula celula) {
    return Container(
      color: _deveDestacarValorSelecionado ? _corDestaqueValorSelecionado : null,
      child: Center(child: _recuperarNumero(celula, false)),
    );
  }

  Widget _gerarCelula(Celula celula) {
    //Célula definida originalmente
    if (celula.isFixo) {
      return _gerarCelulaFixa(celula);
      //Célula com rascunhos
    } else if ((celula.valor == 0 || celula.valor == null) && celula.rascunho.isNotEmpty) {
      return _gerarCelulaRascunho(celula);
      //Célula vazia
    } else if (celula.valor == 0 || celula.valor == null) {
      return Text('');
      //Célula preenchida pelo usuário
    } else {
      return _gerarCelulaPreenchida(celula);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _gerarCelula(celula);
  }
}
