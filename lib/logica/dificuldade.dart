import 'dart:math';
import 'package:flutter/material.dart';

class Dificuldade {
  int min = 17;
  int max = 45;
  String nome = '';
  String caminhoBaseImagem = "imagens/botoes_dificuldade/";
  Image imagem = Image.asset('imagens/botoes_dificuldade/btn_facil.png', fit: BoxFit.contain);

  int quantidadeNumerosFixos() {
    var random = Random();
    return min + random.nextInt((max + 1) - min);
  }
}

class DificuldadeFacil extends Dificuldade {
  DificuldadeFacil() {
    super.min = 36;
    super.max = 45;
    super.nome = 'Fácil';
    super.imagem = Image.asset('${caminhoBaseImagem}btn_facil.png', fit: BoxFit.contain);
  }
}

class DificuldadeMedia extends Dificuldade {
  DificuldadeMedia() {
    super.min = 30;
    super.max = 35;
    super.nome = 'Média';
    super.imagem = Image.asset('${caminhoBaseImagem}btn_medio.png', fit: BoxFit.contain);
  }
}

class DificuldadeDificil extends Dificuldade {
  DificuldadeDificil() {
    super.min = 22;
    super.max = 29;
    super.nome = 'Difícil';
    super.imagem = Image.asset('${caminhoBaseImagem}btn_dificil.png', fit: BoxFit.contain);
  }
}

class DificuldadeExtrema extends Dificuldade {
  DificuldadeExtrema() {
    super.min = 17;
    super.max = 21;
    super.nome = 'Extrema';
  }
}
