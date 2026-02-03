import 'package:flutter/material.dart';

class Teclado extends StatelessWidget {
  const Teclado({
    super.key,
    required this.valoresDisponiveis,
    required this.inserirNumero,
    required this.contagemNumeros,
  });
  final List<int> valoresDisponiveis;
  final Function(int index) inserirNumero;
  final List<int> contagemNumeros;

  void clique(int i) {
    inserirNumero(i);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(9, (index) {
        return Expanded(
          child: GestureDetector(
            onTap: () => clique(index + 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Espaçamento entre botões
              child: AspectRatio(
                aspectRatio: 1, // Mantém o botão quadrado
                child: Container(
                  decoration: contagemNumeros[index] != 9
                      ? BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("imagens/teclado/btn${index + 1}.png"),
                            fit: BoxFit.cover,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
