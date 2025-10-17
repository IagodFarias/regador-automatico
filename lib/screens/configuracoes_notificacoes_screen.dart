import 'package:flutter/material.dart';

class TelaConfiguracoesNotificacoes extends StatefulWidget {
  const TelaConfiguracoesNotificacoes({super.key});

  @override
  State<TelaConfiguracoesNotificacoes> createState() => _TelaConfiguracoesNotificacoesState();
}

class _TelaConfiguracoesNotificacoesState extends State<TelaConfiguracoesNotificacoes> {
  final List<int> temperaturas = [20, 25, 28, 30, 35];
  final List<int> umidades = [40, 50, 60, 70, 80];
  final List<int> luminosidades = [100, 200, 300, 400, 500];

  int? temperaturaSelecionada;
  int? umidadeSelecionada;
  int? luminosidadeSelecionada;

  void salvarConfiguracoes() {
    // 🔹 Futuramente: salvar no banco (Firebase/SQLite)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Configurações salvas com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF015A84),
      appBar: AppBar(
        title: const Text('Configurações de Notificações'),
        backgroundColor: const Color(0xFF015A84),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Seção Temperatura
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<int>(
                  initialValue: temperaturaSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Temperatura (°C)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  dropdownColor: const Color(0xFF015A84),
                  style: const TextStyle(color: Colors.white),
                  items: temperaturas
                      .map((t) => DropdownMenuItem(value: t, child: Text('$t°C')))
                      .toList(),
                  onChanged: (value) => setState(() => temperaturaSelecionada = value),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Seção Umidade
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<int>(
                  initialValue: umidadeSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Umidade (%)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  dropdownColor: const Color(0xFF015A84),
                  style: const TextStyle(color: Colors.white),
                  items: umidades
                      .map((u) => DropdownMenuItem(value: u, child: Text('$u%')))
                      .toList(),
                  onChanged: (value) => setState(() => umidadeSelecionada = value),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Seção Luminosidade
            Card(
              color: Colors.white.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<int>(
                  initialValue: luminosidadeSelecionada,
                  decoration: const InputDecoration(
                    labelText: 'Luminosidade (lux)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  dropdownColor: const Color(0xFF015A84),
                  style: const TextStyle(color: Colors.white),
                  items: luminosidades
                      .map((l) => DropdownMenuItem(value: l, child: Text('$l lux')))
                      .toList(),
                  onChanged: (value) => setState(() => luminosidadeSelecionada = value),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // 🔹 Botão salvar
            Center(
              child: ElevatedButton.icon(
                onPressed: salvarConfiguracoes,
                icon: const Icon(Icons.save),
                label: const Text("Salvar Configurações"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
