class Celula {
  int? valor;
  bool isFixo; // Números que já vêm no desafio
  List<int> rascunho; // Para as "anotações" de cantinho

  Celula({this.valor, this.isFixo = false, this.rascunho = const []});
}
