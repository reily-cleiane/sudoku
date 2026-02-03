import 'dart:math';
import 'dart:developer' as d;
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/modelos/celula.model.dart';
import 'package:sudoku_app/modelos/jogada_invalida.model.dart';

/// Classe responsável pela geração e manipulação de tabuleiros Sudoku

class LogicaSudoku {
  static const int tamanho = 9;
  static const int tamanhoBloco = 3;

  /// Verifica se o número está presente no bloco 3x3
  /// começando na posição (linhaInicio, colunaInicio)
  static (bool, JogadaInvalida?) blocoContemNumero(
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
  static (bool, JogadaInvalida?) linhaContemNumero(List<List<Celula>> tabuleiro, int idxLinha, int num) {
    for (int j = 0; j < tamanho; j++) {
      if (tabuleiro[idxLinha][j].valor == num) {
        return (true, JogadaInvalidaLinha((idxLinha, j)));
      }
    }
    return (false, null);
  }

  /// Verifica se o número está presente na coluna
  static (bool, JogadaInvalida?) colunaContemNumero(List<List<Celula>> tabuleiro, int idxColuna, int num) {
    for (int i = 0; i < tamanho; i++) {
      if (tabuleiro[i][idxColuna].valor == num) {
        return (true, JogadaInvalidaColuna((i, idxColuna)));
      }
    }
    return (false, null);
  }

  /// Verifica se o número pode ser colocado na posição sem violar regras
  static (bool, JogadaInvalida?) verificaValidadeNumero(
    List<List<Celula>> tabuleiro,
    int idxLinha,
    int idxColuna,
    int num,
  ) {
    final (repeteNaLinha, jogInvalidaLinha) = linhaContemNumero(tabuleiro, idxLinha, num);
    final (repeteNaColuna, jogInvalidaColuna) = colunaContemNumero(tabuleiro, idxColuna, num);
    final (repeteNoBloco, jogInvalidaBloco) = blocoContemNumero(
      tabuleiro,
      idxLinha - idxLinha % tamanhoBloco,
      idxColuna - idxColuna % tamanhoBloco,
      num,
    );

    final valido = !repeteNaLinha && !repeteNaColuna && !repeteNoBloco;
    final jogInvalida = JogadaInvalida([jogInvalidaLinha, jogInvalidaColuna, jogInvalidaBloco]);
    return (valido, valido ? null : jogInvalida);
  }

  /// Preenche um bloco 3x3 com números aleatórios de 1 a 9,
  /// garantindo que cada número apareça apenas uma vez
  static void preencheBloco(List<List<Celula>> tabuleiro, int linhaInicio, int colunaInicio) {
    List<int> numeros = List.generate(9, (i) => i + 1);
    numeros.shuffle();

    // for(int i = 0; i < numeros.length; i++){
    //   var a = numeros[i];
    //   d.log("numero $a");
    // }

    int index = 0;
    for (int i = 0; i < tamanhoBloco; i++) {
      for (int j = 0; j < tamanhoBloco; j++) {
        var t = linhaInicio + i;
        var l = colunaInicio + j;
        var a = numeros[index];
        d.log('inserir em $t $l valor $a');
        tabuleiro[linhaInicio + i][colunaInicio + j].valor = numeros[index];
        index++;
      }
    }
  }

  /// Preenche os blocos 3x3 na diagonal do tabuleiro
  static void preencheBlocosDiagonal(List<List<Celula>> tabuleiro) {
    for (int idxInicial = 0; idxInicial < tamanho; idxInicial += tamanhoBloco) {
      preencheBloco(tabuleiro, idxInicial, idxInicial);

      for (int i = 0; i < tabuleiro.length; i++) {
        for (int j = 0; j < tabuleiro.length; j++) {
          var valor = tabuleiro[i][j].valor;
          d.log('tab $valor');
        }
      }
    }
  }

  /// Preenche o restante do tabuleiro usando backtracking
  static bool preencheRestante(List<List<Celula>> tabuleiro, int idxLinha, int idxColuna) {
    // Se chegou ao fim do tabuleiro, sucesso
    if (idxLinha == tamanho) {
      return true;
    }

    // Se chegou ao fim da linha, vai para a próxima
    if (idxColuna == tamanho) {
      return preencheRestante(tabuleiro, idxLinha + 1, 0);
    }

    // Se a célula já está preenchida, vai para a próxima
    if (tabuleiro[idxLinha][idxColuna].valor != 0) {
      return preencheRestante(tabuleiro, idxLinha, idxColuna + 1);
    }

    // Tenta preencher com números de 1 a 9
    for (int num = 1; num <= tamanho; num++) {
      final (numeroValido, jogadaInvalida) = verificaValidadeNumero(tabuleiro, idxLinha, idxColuna, num);
      if (numeroValido) {
        tabuleiro[idxLinha][idxColuna].valor = num;

        if (preencheRestante(tabuleiro, idxLinha, idxColuna + 1)) {
          return true;
        }

        // Desfaz se não conseguiu preencher
        tabuleiro[idxLinha][idxColuna].valor = 0;
      }
    }

    return false;
  }

  /// Conta quantas soluções o tabuleiro possui
  static int contaSolucoes(List<List<Celula>> tabuleiro, int limite) {
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (tabuleiro[i][j].valor == 0) {
          int total = 0;
          for (int num = 1; num <= tamanho; num++) {
            final (numeroValido, jogadaInvalida) = verificaValidadeNumero(tabuleiro, i, j, num);
            if (numeroValido) {
              tabuleiro[i][j].valor = num;
              total += contaSolucoes(tabuleiro, limite);
              tabuleiro[i][j].valor = 0;

              if (total >= limite) {
                return total;
              }
            }
          }
          return total;
        }
      }
    }
    // Não há células vazias - solução válida
    return 1;
  }

  /// Verifica se o tabuleiro tem solução única
  static bool temSolucaoUnica(List<List<Celula>> tabuleiro) {
    return contaSolucoes(tabuleiro, 2) == 1;
  }

  /// Remove k dígitos do tabuleiro garantindo solução única
  static void removeKDigitos(List<List<Celula>> tabuleiro, int k) {
    List<int> celulas = List.generate(81, (i) => i);
    celulas.shuffle();

    int removidos = 0;

    for (int celula in celulas) {
      if (removidos == k) {
        break;
      }

      int i = celula ~/ tamanho;
      int j = celula % tamanho;

      if (tabuleiro[i][j].valor == 0) {
        continue;
      }

      int backup = tabuleiro[i][j].valor ?? 0;
      tabuleiro[i][j].valor = 0;

      // Cria cópia para teste
      List<List<Celula>> tabuleiroTemp = tabuleiro.map((row) => [...row]).toList();

      if (temSolucaoUnica(tabuleiroTemp)) {
        tabuleiro[i][j].isFixo = false;
        removidos++;
      } else {
        // Desfaz se perder unicidade
        tabuleiro[i][j].valor = backup;
      }
    }
  }

  /// Gera um tabuleiro Sudoku completo e válido
  /// k: número de células vazias (dificuldade)
  static List<List<Celula>> gerarTabuleiro(Dificuldade dificuldade) {
    int k = 81 - dificuldade.quantidadeNumerosFixos();
    List<List<Celula>> tabuleiro = List.generate(
      tamanho,
      (_) => List.generate(tamanho, (_) => Celula(valor: 0, isFixo: true)), // CORRETO
    );

    preencheBlocosDiagonal(tabuleiro);

    preencheRestante(tabuleiro, 0, 0);
    removeKDigitos(tabuleiro, k);

    return tabuleiro;
  }

  static (bool, JogadaInvalida?) inserirNumero(List<List<Celula>> tabuleiro, int valor, (int, int)? posicao) {
    if (posicao == null) {
      return (false, null);
    }

    var (valido, jogadaInvalida) = verificaValidadeNumero(tabuleiro, posicao.$1, posicao.$2, valor);

    if (valido) {
      tabuleiro[posicao.$1][posicao.$2] = Celula(isFixo: false, valor: valor, rascunho: []);
      return (true, null);
    }
    return (false, jogadaInvalida);
  }
}
