import 'package:flutter/material.dart';

class BotoesJogo extends StatelessWidget {
  const BotoesJogo({super.key, required this.apagar, required this.desfazer, required this.anotar});

  final Function() apagar;
  final Function() desfazer;
  final Function() anotar;

  Widget _gerarBotao({required IconData icone, required String rotulo, required VoidCallback onTap}) {
    return IconButton(
      iconSize: 40,
      icon: Icon(icone),
      color: const Color.fromARGB(255, 37, 112, 226),
      onPressed: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _gerarBotao(icone: Icons.draw, rotulo: 'Apagar', onTap: apagar),
          _gerarBotao(icone: Icons.history, rotulo: 'Desfazer', onTap: desfazer),
          _gerarBotao(icone: Icons.create, rotulo: 'Anotar', onTap: anotar),
        ],
      ),
    );
  }
}
