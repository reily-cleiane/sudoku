import 'package:shared_preferences/shared_preferences.dart';

class RecordesService {
  static const String _keyPrefix = "recorde_";

  // Salva o tempo se for menor que o anterior (recorde)
  static Future<bool> verificarESalvarRecorde(String dificuldade, int segundos) async {
    final prefs = await SharedPreferences.getInstance();
    int? atual = prefs.getInt(_keyPrefix + dificuldade);

    if (atual == null || segundos < atual) {
      await prefs.setInt(_keyPrefix + dificuldade, segundos);
      return true; // É um novo recorde!
    }
    return false;
  }

  static Future<int?> recuperarRecorde(String dificuldade) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyPrefix + dificuldade);
  }

  // Converte segundos para 00:00
  static String formatarTempo(int segundos) {
    int min = segundos ~/ 60;
    int seg = segundos % 60;
    return "${min.toString().padLeft(2, '0')}:${seg.toString().padLeft(2, '0')}";
  }
}
