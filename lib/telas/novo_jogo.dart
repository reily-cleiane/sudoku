import 'package:flutter/material.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/services/recordes.dart';
import 'package:sudoku_app/telas/jogo.dart';

class NovoJogo extends StatelessWidget {
  const NovoJogo({super.key});

  Widget _exibirRecorde(Dificuldade nivel) {
    return FutureBuilder<int?>(
      future: RecordesService.recuperarRecorde(nivel.runtimeType.toString()),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return Text(
            "Melhor: ${RecordesService.formatarTempo(snapshot.data!)}",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          );
        }
        return const Text("Sem recorde", style: TextStyle(fontSize: 12));
      },
    );
  }

  Widget _gerarBotaoDificuldade(
    BuildContext context,
    BoxConstraints constraints, { // Recebe as restrições da imagem
    required Dificuldade nivel,
    required double topPercent,
  }) {
    // Calcula o tamanho baseado no que a imagem (constraints) realmente tem
    double larguraBotao = constraints.maxWidth * 0.45;
    double alturaBotao = constraints.maxHeight * 0.12;

    return Align(
      alignment: FractionalOffset(0.5, topPercent),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jogo(dificuldade: nivel)));
        },
        child: Container(width: larguraBotao, height: alturaBotao, child: nivel.imagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 243, 229),
      body: Center(
        child: AspectRatio(
          aspectRatio: 512 / 768,
          child: LayoutBuilder(
            // Widget para capturar as dimensões da imagem
            builder: (context, constraints) {
              return Stack(
                children: [
                  Positioned.fill(child: Image.asset("imagens/bg_home.png", fit: BoxFit.fill)),

                  // Pega as 'constraints' para que o botão saiba o tamanho da imagem
                  _gerarBotaoDificuldade(context, constraints, nivel: DificuldadeFacil(), topPercent: 0.33),
                  _gerarBotaoDificuldade(context, constraints, nivel: DificuldadeMedia(), topPercent: 0.51),
                  _gerarBotaoDificuldade(context, constraints, nivel: DificuldadeDificil(), topPercent: 0.7),

                  Align(alignment: const FractionalOffset(0.5, 0.87), child: _exibirRecorde(DificuldadeFacil())),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
