import 'package:flutter/material.dart';
import 'package:sudoku/estilo.dart';
import 'package:sudoku/logica/dificuldade.dart';
import 'package:sudoku/telas/novo_jogo.dart';

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
                Text("Nível: ${dificuldade.nome}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                Text(
                  "Tempo: $tempoGasto",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Estilo.corPreto),
                ),
                if (foiRecorde)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "NOVO RECORDE!",
                      style: TextStyle(color: Estilo.corPrimaria, fontSize: 42, fontWeight: FontWeight.w900),
                    ),
                  ),

                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _navegarTelaNovoJogo(context),
                  child: SizedBox(width: 200, child: Image.asset("imagens/btn_novo_jogo.png", fit: BoxFit.contain)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
