import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/menu_button.dart';
import 'definir_horarios_irrigacao_screen.dart';
import 'graficos_screen.dart';
import 'relatorio_screen.dart';


class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool irrigacaoLigada = false;
  String proximaIrrigacao = "Nenhum horário definido";

  @override
  void initState() {
    super.initState();
    _carregarProximoHorario();
  }

  Future<void> _carregarProximoHorario() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? listaSalva = prefs.getStringList("horarios");

    if (listaSalva != null && listaSalva.isNotEmpty) {
      final horarios = listaSalva.map((h) {
        final partes = h.split(":");
        return TimeOfDay(
          hour: int.parse(partes[0]),
          minute: int.parse(partes[1]),
        );
      }).toList();

      horarios.sort((a, b) =>
          a.hour.compareTo(b.hour) != 0 ? a.hour.compareTo(b.hour) : a.minute.compareTo(b.minute));

      // pega o primeiro como "próxima irrigação"
      setState(() {
        proximaIrrigacao = horarios.first.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF015A84),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Automação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card de status
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF016A9B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    irrigacaoLigada ? Icons.water : Icons.water_drop,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        irrigacaoLigada ? "Ligado" : "Desligado",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        irrigacaoLigada
                            ? "Irrigação em andamento"
                            : "Próxima irrigação\n$proximaIrrigacao",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Botão Iniciar Irrigação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.play_arrow, size: 28),
                label: const Text(
                  "Iniciar Irrigação",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  setState(() {
                    irrigacaoLigada = true;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            // Botão Interromper Irrigação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.stop, size: 28),
                label: const Text(
                  "Interromper Irrigação",
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () {
                  setState(() {
                    irrigacaoLigada = false;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),

            // Agora chama sua nova tela
            const MenuButton(
              imagePath: "assets/images/automacao/horario.png",
              text: "Definir horários de Irrigação",
              destino: TelaDefinirHorarios(),
            ),
            const MenuButton(
              imagePath: "assets/images/automacao/graficos.png",
              text: "Gráficos",
              destino: TelaGraficos(),
            ),
            const MenuButton(
              imagePath: "assets/images/automacao/relatorio.png",
              text: "Relatório",
              destino: TelaRelatorio(),
            ),
          ],
        ),
      ),
    );
  }
}
