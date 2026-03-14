import 'package:flutter/material.dart';
import 'package:sudoku/estilo.dart';
import 'package:sudoku/logica/dificuldade.dart';
import 'package:sudoku/services/recordes.dart';
import 'package:sudoku/telas/jogo.dart';

class NovoJogo extends StatelessWidget {
  const NovoJogo({super.key});

  Widget _exibirRecorde(Dificuldade nivel) {
    return FutureBuilder<int?>(
      future: RecordesService.recuperarRecorde(nivel.runtimeType.toString()),
      builder: (context, snapshot) {
        String texto = snapshot.hasData && snapshot.data != null
            ? "${nivel.nome}: ${RecordesService.formatarTempo(snapshot.data!)}"
            : "${nivel.nome}: Sem recorde";
        return Text(
          texto,
          style: TextStyle(
            fontSize: (MediaQuery.of(context).size.width * 0.04).clamp(20.0, 30.0),
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  Widget _gerarBotaoDificuldade(BuildContext context, {required Dificuldade nivel}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Espaçamento entre botões
      child: Semantics(
        label: 'Iniciar jogo ${nivel.nome}',
        button: true,
        child: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Jogo(dificuldade: nivel)));
          },
          child: SizedBox(
            width: 240, // Largura fixa ou proporcional
            height: 100,
            child: nivel.imagem,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 243, 229),
      body: Stack(
        children: [
          // Fundo fixo
          Positioned.fill(
            child: Image.asset(
              "imagens/bg_home.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter, // Mantém o topo fixo, corta o fundo se necessário
            ),
          ),

          Positioned.fill(
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.only(top: MediaQuery.of(context).size.height * 0.05),
                      child: Text(
                        'Sudoku',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 70, color: Estilo.corPrimaria, fontWeight: FontWeight.w600),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsGeometry.only(top: MediaQuery.of(context).size.height * 0.1, bottom: 40),
                      child: Column(
                        children: [
                          _gerarBotaoDificuldade(context, nivel: DificuldadeFacil()),
                          _exibirRecorde(DificuldadeFacil()),
                          Padding(padding: EdgeInsetsGeometry.only(bottom: 10)),
                          _gerarBotaoDificuldade(context, nivel: DificuldadeMedia()),
                          _exibirRecorde(DificuldadeMedia()),
                          Padding(padding: EdgeInsetsGeometry.only(bottom: 10)),
                          _gerarBotaoDificuldade(context, nivel: DificuldadeDificil()),
                          _exibirRecorde(DificuldadeDificil()),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
