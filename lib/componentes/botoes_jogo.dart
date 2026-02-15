import 'package:flutter/material.dart';

class BotoesJogo extends StatelessWidget {
  const BotoesJogo({super.key, required this.apagar, required this.desfazer, required this.anotar});

  final VoidCallback apagar;
  final VoidCallback desfazer;
  final VoidCallback anotar;

  Widget _gerarBotao({required String nomeImagem, required String rotulo, required VoidCallback onTap}) {
    return Expanded(
      // Força os botões a dividirem o espaço disponível igualmente
      child: IconButton(
        // O constraints garante que o botão não cresça além de um limite razoável
        constraints: const BoxConstraints(maxWidth: 80, maxHeight: 80),
        icon: Image.asset(
          "imagens/botoes_jogo/$nomeImagem",
          fit: BoxFit.contain, // Faz a imagem caber dentro do ícone sem distorcer
        ),
        onPressed: onTap,
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
          _gerarBotao(nomeImagem: 'btn_apagar.png', rotulo: 'Apagar', onTap: apagar),
          _gerarBotao(nomeImagem: 'btn_desfazer.png', rotulo: 'Desfazer', onTap: desfazer),
          _gerarBotao(nomeImagem: 'btn_rascunho.png', rotulo: 'Anotar', onTap: anotar),
        ],
      ),
    );
  }
}
