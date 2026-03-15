import 'package:flutter/material.dart';
import 'package:sudoku/estilo.dart';
import 'dart:async';

import 'package:sudoku/services/recordes.dart';

class CronometroJogo extends StatefulWidget {
  const CronometroJogo({super.key, required this.onTempoAtualizado});

  final Function(int segundos) onTempoAtualizado;

  @override
  State<CronometroJogo> createState() => _CronometroJogoState();
}

class _CronometroJogoState extends State<CronometroJogo> {
  Timer? _timer;
  int _segundos = 0;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _segundos++;
      });

      widget.onTempoAtualizado(_segundos);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      RecordesService.formatarTempo(_segundos),
      textAlign: TextAlign.end,
      style: TextStyle(
        fontSize: (MediaQuery.of(context).size.width * 0.045).clamp(22.0, 35.0),
        fontWeight: FontWeight.w600,
        color: Estilo.corSecundaria,
      ),
    );
  }
}
