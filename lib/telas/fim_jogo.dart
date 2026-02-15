import 'package:flutter/material.dart';
import 'package:sudoku_app/logica/dificuldade.dart';
import 'package:sudoku_app/telas/novo_jogo.dart';

class FimJogo extends StatelessWidget {
  final String tempoGasto;
  final Dificuldade dificuldade;
  final bool foiRecorde;

  const FimJogo({super.key, required this.tempoGasto, required this.dificuldade, this.foiRecorde = false});

  void _navegarTelaNovoJogo(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NovoJogo()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 243, 229),
      body: Stack(
        children: [
          Positioned.fill(child: Image.asset("imagens/bg_fim.png", fit: BoxFit.fitHeight)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.55),
                Text("Nível: ${dificuldade.nome}", style: const TextStyle(fontSize: 18)),
                Text("Tempo: $tempoGasto", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                if (foiRecorde)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text("NOVO RECORDE!", style: TextStyle(color: Colors.orange, fontSize: 30)),
                  ),

                GestureDetector(
                  onTap: () => _navegarTelaNovoJogo(context),
                  child: Image.asset("imagens/btn_novo_jogo.png", fit: BoxFit.contain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
