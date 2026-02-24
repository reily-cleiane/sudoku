import 'package:flutter/material.dart';

class BotoesJogo extends StatelessWidget {
  const BotoesJogo({super.key, required this.apagar, required this.desfazer, required this.anotar});

  final VoidCallback apagar;
  final VoidCallback desfazer;
  final VoidCallback anotar;

  Widget _gerarBotao({required String nomeImagem, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0), // Espaçamento entre botões
          child: AspectRatio(
            aspectRatio: 1.4782, // Mantém o botão quadrado
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("imagens/botoes_jogo/$nomeImagem"), fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          _gerarBotao(nomeImagem: 'btn_apagar.png', onTap: apagar),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          _gerarBotao(nomeImagem: 'btn_desfazer.png', onTap: desfazer),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
          _gerarBotao(nomeImagem: 'btn_rascunho.png', onTap: anotar),
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        ],
      ),
    );
  }
}
