import 'package:sudoku/logica/dificuldade.dart';
import 'package:sudoku/modelos/celula.model.dart';

/// Classe responsável pela geração de tabuleiros Sudoku
class LogicaGeracaoTabuleiro {
  static const int tamanho = 9;
  static const int tamanhoBloco = 3;
  static List<int> linhaMask = List.filled(tamanho, 0);
  static List<int> colunaMask = List.filled(tamanho, 0);
  static List<int> blocoMask = List.filled(tamanho, 0);

  /// Calcula o índice do bloco 3x3 para a posição (linha, coluna)
  static int _blocoIndex(int linha, int coluna) {
    return (linha ~/ tamanhoBloco) * tamanhoBloco + (coluna ~/ tamanhoBloco);
  }

  /// Verifica se um número pode ser inserido na posição (linha, coluna) sem violar as regras do Sudoku, usando as máscaras de bit para eficiência
  static bool _podeInserir(int linha, int coluna, int num) {
    int bit = 1 << (num - 1);
    int bloco = _blocoIndex(linha, coluna);

    return (linhaMask[linha] & bit) == 0 && (colunaMask[coluna] & bit) == 0 && (blocoMask[bloco] & bit) == 0;
  }

  /// Coloca um número na posição (linha, coluna) do tabuleiro
  static void _colocarNumero(int linha, int coluna, int num) {
    int bit = 1 << (num - 1);
    int bloco = _blocoIndex(linha, coluna);

    linhaMask[linha] |= bit;
    colunaMask[coluna] |= bit;
    blocoMask[bloco] |= bit;
  }

  /// Remove um número da posição (linha, coluna) das máscaras de bit,
  /// usado durante o processo de backtracking para gerar o tabuleiro
  static void _removerNumero(int linha, int coluna, int num) {
    int bit = 1 << (num - 1);
    int bloco = _blocoIndex(linha, coluna);

    linhaMask[linha] &= ~bit;
    colunaMask[coluna] &= ~bit;
    blocoMask[bloco] &= ~bit;
  }

  /// Preenche um bloco 3x3 com números aleatórios de 1 a 9,
  /// garantindo que cada número apareça apenas uma vez
  static void _preencheBloco(List<List<Celula>> tabuleiro, int linhaInicio, int colunaInicio) {
    List<int> numeros = List.generate(tamanho, (i) => i + 1);
    numeros.shuffle();

    int index = 0;
    for (int i = 0; i < tamanhoBloco; i++) {
      for (int j = 0; j < tamanhoBloco; j++) {
        tabuleiro[linhaInicio + i][colunaInicio + j].valor = numeros[index];
        index++;
      }
    }
  }

  /// Preenche os blocos 3x3 na diagonal do tabuleiro
  static void _preencheBlocosDiagonal(List<List<Celula>> tabuleiro) {
    for (int idxInicial = 0; idxInicial < tamanho; idxInicial += tamanhoBloco) {
      _preencheBloco(tabuleiro, idxInicial, idxInicial);
    }
  }

  /// Preenche o restante do tabuleiro usando backtracking
  static bool _preencheRestante(List<List<Celula>> tabuleiro, int linha, int coluna) {
    if (linha == 9) return true;

    int proxLinha = coluna == 8 ? linha + 1 : linha;
    int proxColuna = (coluna + 1) % 9;

    if (tabuleiro[linha][coluna].valor != 0) {
      return _preencheRestante(tabuleiro, proxLinha, proxColuna);
    }

    List<int> numeros = List.generate(9, (i) => i + 1)..shuffle();

    for (int num in numeros) {
      if (_podeInserir(linha, coluna, num)) {
        tabuleiro[linha][coluna].valor = num;
        _colocarNumero(linha, coluna, num);

        if (_preencheRestante(tabuleiro, proxLinha, proxColuna)) {
          return true;
        }

        tabuleiro[linha][coluna].valor = 0;
        _removerNumero(linha, coluna, num);
      }
    }

    return false;
  }

  /// Inicializa as máscaras de linha, coluna e bloco com base no tabuleiro gerado
  /// para facilitar verificação de valida de número em dada posição ao preencher o restante do tabuleiro
  static void _inicializaMasks(List<List<Celula>> tabuleiro) {
    linhaMask = List.filled(tamanho, 0);
    colunaMask = List.filled(tamanho, 0);
    blocoMask = List.filled(tamanho, 0);

    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        int num = tabuleiro[i][j].valor ?? 0;

        if (num != 0) {
          _colocarNumero(i, j, num);
        }
      }
    }
  }

  /// Verifica se um número é válido na posição do tabuleiro
  static bool _validoInt(List<List<int>> tabuleiro, int linha, int coluna, int num) {
    for (int i = 0; i < tamanho; i++) {
      if (tabuleiro[linha][i] == num) return false;
      if (tabuleiro[i][coluna] == num) return false;
    }

    int linhaInicio = linha - linha % tamanhoBloco;
    int colunaInicio = coluna - coluna % tamanhoBloco;

    for (int i = 0; i < tamanhoBloco; i++) {
      for (int j = 0; j < tamanhoBloco; j++) {
        if (tabuleiro[linhaInicio + i][colunaInicio + j] == num) {
          return false;
        }
      }
    }

    return true;
  }

  /// Conta quantas soluções o tabuleiro possui
  static int _contaSolucoesInt(List<List<int>> tabuleiro, int limite) {
    for (int i = 0; i < tamanho; i++) {
      for (int j = 0; j < tamanho; j++) {
        if (tabuleiro[i][j] == 0) {
          int total = 0;

          List<int> numeros = List.generate(tamanho, (i) => i + 1)..shuffle();

          for (int num in numeros) {
            if (_validoInt(tabuleiro, i, j, num)) {
              tabuleiro[i][j] = num;

              total += _contaSolucoesInt(tabuleiro, limite);

              tabuleiro[i][j] = 0;

              if (total >= limite) {
                return total;
              }
            }
          }

          return total;
        }
      }
    }
    //Não há células vazias, solução válida
    return 1;
  }

  /// Verifica se o tabuleiro tem solução única
  static bool _temSolucaoUnica(List<List<Celula>> tabuleiro) {
    List<List<int>> copia = tabuleiro.map((row) => row.map((c) => c.valor ?? 0).toList()).toList();

    return _contaSolucoesInt(copia, 2) == 1;
  }

  /// Remove k dígitos do tabuleiro garantindo solução única
  static void _removeKDigitos(List<List<Celula>> tabuleiro, int k) {
    List<int> celulas = List.generate(81, (i) => i);
    celulas.shuffle();

    int removidos = 0;

    //Tem 81 elementos (índice 80), loop até o 79 porque pega internamente o índice + 1 também
    for (int indice = 0; indice < 80; indice += 2) {
      if (removidos >= k) {
        return;
      }

      int celula = celulas[indice];
      int celula2 = celulas[indice + 1];

      int i = celula ~/ tamanho;
      int j = celula % tamanho;
      int i2 = celula2 ~/ tamanho;
      int j2 = celula2 % tamanho;

      int backup = tabuleiro[i][j].valor ?? 0;
      tabuleiro[i][j].valor = 0;

      int backup2 = tabuleiro[i2][j2].valor ?? 0;
      tabuleiro[i2][j2].valor = 0;

      if (_temSolucaoUnica(tabuleiro)) {
        tabuleiro[i][j].isFixo = false;
        removidos++;
        if (removidos >= k) {
          tabuleiro[i2][j2].valor = backup2;
          return;
        }
        tabuleiro[i2][j2].isFixo = false;
        removidos++;
      } else {
        // Desfaz se perder unicidade
        tabuleiro[i][j].valor = backup;
        tabuleiro[i2][j2].valor = backup2;
      }

      if (removidos < k && indice + 2 >= 80) {
        // Se ainda precisa remover mais e já chegou no final da lista, reinicia o processo
        celulas.shuffle();
        indice = -2; // Será incrementado para 0 no próximo loop
      }
    }
  }

  /// Gera um tabuleiro Sudoku completo e válido
  /// k: número de células vazias (dificuldade)
  static List<List<Celula>> gerarTabuleiro(Dificuldade dificuldade) {
    int k = (tamanho * tamanho) - dificuldade.quantidadeNumerosFixos();

    List<List<Celula>> tabuleiro = List.generate(
      tamanho,
      (_) => List.generate(tamanho, (_) => Celula(valor: 0, isFixo: true)),
    );

    _preencheBlocosDiagonal(tabuleiro);

    _inicializaMasks(tabuleiro);

    _preencheRestante(tabuleiro, 0, 0);
    _removeKDigitos(tabuleiro, k);

    return tabuleiro;
  }
}
