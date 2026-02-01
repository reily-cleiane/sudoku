import 'dart:math';
class Dificuldade {
  int min = 17;
  int max = 45;

  int quantidadeNumerosFixos(){
    var random = Random();
    return min + random.nextInt((max + 1) - min);
  }
}

class DificuldadeFacil extends Dificuldade{
  DificuldadeFacil(){
    super.min = 36;
    super.max = 45;
  }
}

class DificuldadeMedia extends Dificuldade{
  DificuldadeMedia(){
    super.min = 30;
    super.max = 35;
  }
}

class DificuldadeDificil extends Dificuldade{
  DificuldadeDificil(){
    super.min = 22;
    super.max = 29;
  }
}

class DificuldadeExtrema extends Dificuldade{
  DificuldadeExtrema(){
    super.min = 17;
    super.max = 21;
  }
}

