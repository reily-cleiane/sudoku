import 'dart:async';
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
import 'package:sudoku_app/services/recordes.dart';
import 'package:sudoku_app/telas/fim_jogo.dart';

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
  final double paddingPadrao = 20;
  Timer? _timer;
  int _segundosDecorridos = 0;

  @override
  void initState() {
    super.initState();
    tabuleiro = LogicaSudoku.gerarTabuleiro(widget.dificuldade);
    contagemNumeros = LogicaSudoku.contarNumeros(tabuleiro);
    _iniciarCronometro();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Importante para não vazar memória
    super.dispose();
  }

  void _iniciarCronometro() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _segundosDecorridos++;
      });
    });
  }

  bool _terminouJogo() {
    for (int cont in contagemNumeros) {
      if (cont != 9) {
        return false;
      }
    }
    return true;
  }

  void _finalizarJogo() async {
    _timer?.cancel();

    bool novoRecorde = await RecordesService.verificarESalvarRecorde(
      widget.dificuldade.runtimeType.toString(),
      _segundosDecorridos,
    );

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FimJogo(
          tempoGasto: RecordesService.formatarTempo(_segundosDecorridos),
          dificuldade: widget.dificuldade,
          foiRecorde: novoRecorde,
        ),
      ),
    );
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

  void _anotar() {
    setState(() {
      modoRascunho = !modoRascunho;
    });
  }

  void _inserirAnotacao(int valor) {
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
      _inserirAnotacao(valor);
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

        if (_terminouJogo()) {
          _finalizarJogo();
        }
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
                Text(RecordesService.formatarTempo(_segundosDecorridos)),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(paddingPadrao),
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
                  padding: EdgeInsets.symmetric(horizontal: paddingPadrao, vertical: 0),
                  alignment: Alignment.centerRight,
                  child: Text(
                    modoRascunho == true ? "Modo de rascunho" : "",
                    style: TextStyle(color: Estilo.corFonteRascunho, fontSize: 16.0),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingPadrao, vertical: 10),
                  child: BotoesJogo(apagar: apagar, desfazer: desfazer, anotar: _anotar),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: paddingPadrao, vertical: 10),
                  child: Teclado(
                    valoresDisponiveis: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
                    inserirNumero: (valor) => _inserirNumero(valor),
                    contagemNumeros: contagemNumeros,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
