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

  Widget _gerarBotaoDificuldade(BuildContext context, {required Dificuldade nivel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),

      child: ElevatedButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jogo(dificuldade: nivel)));
        },

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(230, 244, 241, 236),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          padding: EdgeInsets.zero, // <--add this
        ),
        child: nivel.imagem,
      ),
      // child: IconButton(
      //   iconSize: 80, // Tamanho que a imagem ocupará
      //   onPressed: () {
      //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jogo(dificuldade: nivel)));
      //   },
      //   icon: Image.asset("imagens/botoes_dificuldade/$imagem", fit: BoxFit.contain),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset("imagens/bg.jpg", fit: BoxFit.cover)),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "SUDOKU",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  const SizedBox(height: 50),
                  _gerarBotaoDificuldade(context, nivel: DificuldadeFacil()),
                  _gerarBotaoDificuldade(context, nivel: DificuldadeMedia()),
                  _gerarBotaoDificuldade(context, nivel: DificuldadeDificil()),
                  const SizedBox(height: 50),
                  _exibirRecorde(DificuldadeFacil()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
