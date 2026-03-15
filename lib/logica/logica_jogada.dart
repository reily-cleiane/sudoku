import 'package:sudoku/modelos/celula.model.dart';
import 'package:sudoku/logica/jogada_invalida.dart';

/// Classe responsável pela lógica de validação de jogadas e inserção de números no tabuleiro pelo jogador
class LogicaJogada {
  static const int tamanho = 9;
  static const int tamanhoBloco = 3;

  /// Verifica se o número está presente no bloco
  /// começando na posição (linhaInicio, colunaInicio)
  static (bool, JogadaInvalida?) _blocoContemNumero(
    List<List<Celula>> tabuleiro,
    int linhaInicio,
    int colunaInicio,
    int num,
  ) {
    for (int i = 0; i < tamanhoBloco; i++) {
      for (int j = 0; j < tamanhoBloco; j++) {
        if (tabuleiro[linhaInicio + i][colunaInicio + j].valor == num) {
          return (true, JogadaInvalidaBloco((linhaInicio + i, colunaInicio + j)));
        }
      }
    }
    return (false, null);
  }

  /// Verifica se o número está presente na linha
  static (bool, JogadaInvalida?) _linhaContemNumero(List<List<Celula>> tabuleiro, int idxLinha, int num) {
    for (int j = 0; j < tamanho; j++) {
      if (tabuleiro[idxLinha][j].valor == num) {
        return (true, JogadaInvalidaLinha((idxLinha, j)));
      }
    }
    return (false, null);
  }

  /// Verifica se o número está presente na coluna
  static (bool, JogadaInvalida?) _colunaContemNumero(List<List<Celula>> tabuleiro, int idxColuna, int num) {
    for (int i = 0; i < tamanho; i++) {
      if (tabuleiro[i][idxColuna].valor == num) {
        return (true, JogadaInvalidaColuna((i, idxColuna)));
      }
    }
    return (false, null);
  }

  /// Verifica se o número pode ser colocado na posição sem violar regras
  static (bool, JogadaInvalida?) _verificaValidadeNumero(
    List<List<Celula>> tabuleiro,
    int idxLinha,
    int idxColuna,
    int num,
  ) {
    final (repeteNaLinha, jogInvalidaLinha) = _linhaContemNumero(tabuleiro, idxLinha, num);
    final (repeteNaColuna, jogInvalidaColuna) = _colunaContemNumero(tabuleiro, idxColuna, num);
    final (repeteNoBloco, jogInvalidaBloco) = _blocoContemNumero(
      tabuleiro,
      idxLinha - idxLinha % tamanhoBloco,
      idxColuna - idxColuna % tamanhoBloco,
      num,
    );

    final valido = !repeteNaLinha && !repeteNaColuna && !repeteNoBloco;
    final jogInvalida = JogadaInvalida([jogInvalidaLinha, jogInvalidaColuna, jogInvalidaBloco]);
    return (valido, valido ? null : jogInvalida);
  }

  /// Ação do usuário de inserir número no tabuleiro, retorna se a jogada é válida e, se não for, qual regra foi violada
  /// Altera o tabuleiro com a inserção de jogada válida
  /// Retorno: (bool, JogadaInvalida?) -> (é válida?, se não for, qual regra foi violada?)
  static (bool, JogadaInvalida?) inserirNumero(List<List<Celula>> tabuleiro, int valor, (int, int)? posicao) {
    if (posicao == null) {
      return (false, null);
    }

    var (valido, jogadaInvalida) = _verificaValidadeNumero(tabuleiro, posicao.$1, posicao.$2, valor);

    if (valido) {
      tabuleiro[posicao.$1][posicao.$2] = Celula(isFixo: false, valor: valor, rascunho: []);
      return (true, null);
    }
    return (false, jogadaInvalida);
  }
}
