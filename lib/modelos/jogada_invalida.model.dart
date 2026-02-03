import 'package:sudoku_app/modelos/posicao.model.dart';

class JogadaInvalida {
  bool? repeteNaLinha;
  bool? repeteNaColuna;
  bool? repeteNoBloco;

  Posicao? posicaoDuplicadaNaLinha;
  Posicao? posicaoDuplicadaNaColuna;
  Posicao? posicaoDuplicadaNoBloco;

  JogadaInvalida(List<JogadaInvalida?> jogadasInvalidas) {
    repeteNaLinha = jogadasInvalidas.any((jogada) => jogada?.repeteNaLinha == true);
    repeteNaColuna = jogadasInvalidas.any((jogada) => jogada?.repeteNaColuna == true);
    repeteNoBloco = jogadasInvalidas.any((jogada) => jogada?.repeteNoBloco == true);
    posicaoDuplicadaNaLinha = jogadasInvalidas
        .cast<JogadaInvalida?>()
        .firstWhere((jogada) => jogada?.posicaoDuplicadaNaLinha != null, orElse: () => null)
        ?.posicaoDuplicadaNaLinha;
    posicaoDuplicadaNaColuna = jogadasInvalidas
        .cast<JogadaInvalida?>()
        .firstWhere((jogada) => jogada?.posicaoDuplicadaNaColuna != null, orElse: () => null)
        ?.posicaoDuplicadaNaColuna;
    posicaoDuplicadaNoBloco = jogadasInvalidas
        .cast<JogadaInvalida?>()
        .firstWhere((jogada) => jogada?.posicaoDuplicadaNoBloco != null, orElse: () => null)
        ?.posicaoDuplicadaNoBloco;
  }
}

class JogadaInvalidaLinha extends JogadaInvalida {
  JogadaInvalidaLinha(Posicao posicao) : super([]) {
    repeteNaLinha = true;
    posicaoDuplicadaNaLinha = posicao;
  }
}

class JogadaInvalidaColuna extends JogadaInvalida {
  JogadaInvalidaColuna(Posicao posicao) : super([]) {
    repeteNaColuna = true;
    posicaoDuplicadaNaColuna = posicao;
  }
}

class JogadaInvalidaBloco extends JogadaInvalida {
  JogadaInvalidaBloco(Posicao posicao) : super([]) {
    repeteNoBloco = true;
    posicaoDuplicadaNoBloco = posicao;
  }
}
