import 'package:flutter/material.dart';
import 'package:sudoku_app/estilo.dart';
import 'package:sudoku_app/modelos/celula.model.dart';

/// Classe responsável por gerar o conteúdo formatado de uma célula do grid
class CelulaGrid extends StatefulWidget {
  const CelulaGrid({
    super.key,
    required this.celula,
    this.valorSelecionado,
    this.celulaEstaNaMesmaLinhaOuColuna = false,
    this.estaSelecionada = false,
    this.posicaoParaPiscar = false, // Gatilho para piscar
    this.gatilho = false,
    this.devePiscar = false,
  });

  final Celula celula;
  final int? valorSelecionado;
  final bool celulaEstaNaMesmaLinhaOuColuna;
  final bool estaSelecionada;
  final bool posicaoParaPiscar;
  final bool gatilho;
  final bool devePiscar;

  @override
  State<CelulaGrid> createState() => _CelulaGridState();
}

class _CelulaGridState extends State<CelulaGrid> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animationPisca;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _animationPisca = ColorTween(
      begin: Colors.transparent,
      end: Estilo.corDestaqueBackgroundDuplicado,
    ).animate(_controller);
  }

  @override
  void didUpdateWidget(CelulaGrid oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 1. O gatilho mudou? (Houve erro em algum lugar do grid)
    // 2. Eu sou a célula que deve piscar?
    if (widget.gatilho != oldWidget.gatilho && widget.devePiscar) {
      _controller.forward(from: 0.0).then((_) => _controller.reverse());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color? _getCorFundo() {
    // Ordem de prioridade dos destaques visuais
    if (widget.estaSelecionada) return Estilo.corDestaqueBackgroundCelulaSelecionada;

    if (widget.valorSelecionado != null && widget.celula.valor != 0 && widget.celula.valor == widget.valorSelecionado) {
      return Estilo.corDestaqueBackgroundValorSelecionado;
    }

    if (widget.celulaEstaNaMesmaLinhaOuColuna) return Estilo.corDestaqueBackgroundLinhaColuna;

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationPisca,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.all(2),
          child: Container(
            // O Stack permite sobrepor a cor de destaque fixo com a cor da animação (pisca)
            decoration: BoxDecoration(color: _getCorFundo()),
            child: Container(
              color: _animationPisca.value, // Cor do pisca sobreposta
              child: _construirConteudo(),
            ),
          ),
        );
      },
    );
  }

  Widget _construirConteudo() {
    if (widget.celula.valor != 0) {
      bool fixo = widget.celula.isFixo;
      String nome = fixo ? "${widget.celula.valor}.png" : "${widget.celula.valor}a.png";
      return Padding(padding: const EdgeInsets.all(10), child: Image.asset("imagens/imgs_celulas/$nome"));
    }

    if (widget.celula.rascunho.isNotEmpty) {
      return _gerarGridRascunho();
    }

    return const SizedBox.shrink();
  }

  Widget _gerarGridRascunho() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.0,
      children: List.generate(9, (index) {
        int num = index + 1;
        bool existe = widget.celula.rascunho.contains(num);
        bool destacaRascunho = widget.valorSelecionado == num && existe;

        return Container(
          color: destacaRascunho ? Estilo.corDestaqueBackgroundValorSelecionado.withValues(alpha: 0.4) : null,
          alignment: Alignment.center,
          child: Text(existe ? '$num' : '', style: const TextStyle(fontSize: 10), textAlign: TextAlign.center),
        );
      }),
    );
  }
}
