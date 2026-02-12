import 'package:flutter/material.dart';
import 'package:sudoku_app/componentes/botoes_jogo.dart';
import 'package:sudoku_app/componentes/grid.dart';
import 'package:sudoku_app/componentes/teclado.dart';
import 'package:sudoku_app/estilo.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/logica/logica.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/historico_jogada.model.dart';
import 'package:sudoku_app/modelos/posicao.model.dart';

class Jogo extends StatefulWidget {
  //Recebe key (que é padrão do framework, título, e dificuldade do jogo)
  const Jogo({super.key, required this.dificuldade});
  final Dificuldade dificuldade;

  @override
  JogoState createState() => JogoState();
}

class JogoState extends State<Jogo> {
  List<List<Celula>> tabuleiro = [];
  (int, int)? posicaoSelecionada;
  Posicao? posicaoErroDuplicidade;
  List<int> contagemNumeros = [];
  Posicao? ultimaPosicaoJogada;
  int? ultimoValorSubstituido;
  bool modoRascunho = false;
  List<HistoricoJogada> pilhaDesfazer = [];

  @override
  void initState() {
    super.initState();
    tabuleiro = LogicaSudoku.gerarTabuleiro(widget.dificuldade);
    contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
  }

  void apagar() {
    if (posicaoSelecionada != null && !tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].isFixo) {
      setState(() {
        tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].rascunho = [];
        tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].valor = 0;
      });
    }
  }

  void desfazer() {
    if (ultimaPosicaoJogada != null && ultimoValorSubstituido != null && pilhaDesfazer.isNotEmpty) {
      setState(() {
        final ultimaJogada = pilhaDesfazer.removeLast();
        // Reverte o valor no tabuleiro
        tabuleiro[ultimaJogada.posicao.$1][ultimaJogada.posicao.$2].valor = ultimaJogada.valorAntigo;
        // Atualiza teclado
        contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
      });
    }
  }

  void anotar() {
    setState(() {
      modoRascunho = !modoRascunho;
    });
  }

  void inserirAnotacao(int valor) {
    if (posicaoSelecionada == null || tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].isFixo) {
      return;
    }
    final anotacaoExistente = tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].rascunho;
    final (sucesso, jogadaInvalida) = LogicaSudoku.inserirNumero(tabuleiro, valor, posicaoSelecionada);
    if (sucesso) {
      setState(() {
        tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].valor = 0;
        for (var anotacao in anotacaoExistente) {
          tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].rascunho.add(anotacao);
        }
        tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].rascunho.add(valor);
      });
      return;
    }
  }

  void _inserirNumero(int valor) {
    if (modoRascunho == true) {
      inserirAnotacao(valor);
      return;
    }

    if (posicaoSelecionada == null || tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].isFixo) {
      return;
    }
    final valorSubstituidoTemporario = tabuleiro[posicaoSelecionada!.$1][posicaoSelecionada!.$2].valor;

    final (sucesso, jogadaInvalida) = LogicaSudoku.inserirNumero(tabuleiro, valor, posicaoSelecionada);

    if (sucesso) {
      setState(() {
        pilhaDesfazer.add((posicao: posicaoSelecionada!, valorAntigo: valorSubstituidoTemporario, valorNovo: valor));

        contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
        posicaoErroDuplicidade = null;
      });
      return;
    }

    if (jogadaInvalida?.repeteNaLinha == true && jogadaInvalida?.posicaoDuplicadaNaLinha != null) {
      setState(() {
        posicaoErroDuplicidade = jogadaInvalida!.posicaoDuplicadaNaLinha;
      });
      return;
    }

    if (jogadaInvalida?.repeteNaColuna == true && jogadaInvalida?.posicaoDuplicadaNaColuna != null) {
      setState(() {
        posicaoErroDuplicidade = jogadaInvalida!.posicaoDuplicadaNaColuna;
      });
      return;
    }

    if (jogadaInvalida?.repeteNoBloco == true && jogadaInvalida?.posicaoDuplicadaNoBloco != null) {
      setState(() {
        posicaoErroDuplicidade = jogadaInvalida!.posicaoDuplicadaNoBloco;
      });
      return;
    }
  }

  void _celulaClicada(Posicao posicao) {
    posicaoSelecionada = posicao;
    posicaoErroDuplicidade = null;
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
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                      aspectRatio: 1.0,
                      child: GridSudoku(
                        tabuleiro: tabuleiro,
                        eventoCelulaClicada: (posicao) => _celulaClicada(posicao),
                        posicaoErroDuplicidade: posicaoErroDuplicidade,
                      ),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    modoRascunho == true ? "Modo de rascunho" : "",
                    style: TextStyle(color: Estilo.corFonteRascunho, fontSize: 16.0),
                  ),
                ),
                BotoesJogo(apagar: apagar, desfazer: desfazer, anotar: anotar),
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
