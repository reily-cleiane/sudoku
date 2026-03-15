import 'package:sudoku/logica/dificuldade.dart';
import 'package:sudoku/logica/logica-geracao-tabuleiro.dart';
import 'package:sudoku/logica/logica_jogada.dart';
import 'package:sudoku/modelos/celula.model.dart';
import 'package:sudoku/logica/jogada_invalida.dart';

/// Classe responsável pela geração e manipulação de tabuleiros Sudoku

class LogicaSudoku {
  static const int tamanho = 9;
  static const int tamanhoBloco = 3;

  /// Gera um tabuleiro Sudoku completo e válido
  static List<List<Celula>> gerarTabuleiro(Dificuldade dificuldade) {
    return LogicaGeracaoTabuleiro.gerarTabuleiro(dificuldade);
  }

  /// Ação do usuário de inserir número no tabuleiro, retorna se a jogada é válida e, se não for, qual regra foi violada
  static (bool, JogadaInvalida?) inserirNumero(List<List<Celula>> tabuleiro, int valor, (int, int)? posicao) {
    return LogicaJogada.inserirNumero(tabuleiro, valor, posicao);
  }

  /// Conta quantas vezes cada número aparece no tabuleiro.
  /// Usado para identificar os botões do teclado que devem ser exibidos
  static List<int> contarNumeros(List<List<Celula>> tabuleiro) {
    var contagem = List<int>.filled(tamanho, 0);
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (tabuleiro[i][j].valor != null && tabuleiro[i][j].valor != 0) {
          contagem[tabuleiro[i][j].valor! - 1] = contagem[tabuleiro[i][j].valor! - 1] + 1;
        }
      }
    }
    return contagem;
  }
}
