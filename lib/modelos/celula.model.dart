class Celula {
  int? valor;
  bool eFixo; // Números que já vêm no desafio
  bool eErrado;
  List<int> rascunho; // Para as "anotações" de cantinho

  Celula({
    this.valor,
    this.eFixo = false,
    this.eErrado = false,
    this.rascunho = const [],
  });
}