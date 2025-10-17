import 'package:flutter/material.dart';
import '../widgets/info_card.dart';
import 'automacao_screen.dart';

class TelaDetalhePlanta extends StatelessWidget {
  final String nomePlanta;
  final String caminhoImagem;

  const TelaDetalhePlanta({
    super.key,
    required this.nomePlanta,
    required this.caminhoImagem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(nomePlanta)),
      backgroundColor: const Color(0xFF015A84),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card grande com imagem
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF016A9B),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Image.asset(caminhoImagem, height: 100),
                  const SizedBox(height: 12),
                  Text(
                    nomePlanta.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Linha com 3 cards: temperatura, umidade e luminosidade
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InfoCard(
                  icon: Icons.thermostat,
                  valor: "30°C",
                  label: "Temperatura",
                  color: Colors.redAccent,
                ),
                InfoCard(
                  icon: Icons.water_drop,
                  valor: "57%",
                  label: "Umidade",
                  color: Colors.blueAccent,
                ),
                InfoCard(
                  icon: Icons.wb_sunny,
                  valor: "Intensa",
                  label: "Luminosidade",
                  color: Colors.amber,
                ),
              ],
            ),
            const Spacer(),

            // Botão Automação
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF096591),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TelaPrincipal()),
                  );
                },
                child: const Text(
                  "AUTOMAÇÃO",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}