import 'package:flutter/material.dart';

class AdicionarPlantaScreen extends StatefulWidget {
  final Map<String, String>? plantaExistente;
  const AdicionarPlantaScreen({this.plantaExistente, super.key});

  @override
  State<AdicionarPlantaScreen> createState() => _AdicionarPlantaScreenState();
}

class _AdicionarPlantaScreenState extends State<AdicionarPlantaScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _localizacaoController;
  String? _nomeSelecionado;

  final List<String> opcoesPlantas = [
    'Alface', 'Tomate', 'Milho', 'Cenoura', 'Maçã', 'Morango',
  ];

  @override
  void initState() {
    super.initState();
    _nomeSelecionado = widget.plantaExistente?['nome'];
    _localizacaoController =
        TextEditingController(text: widget.plantaExistente?['localizacao'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1EDEA),
      appBar: AppBar(
        title: const Text('Adicionar Planta'),
        backgroundColor: const Color(0xFF096591),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _nomeSelecionado,
                decoration: const InputDecoration(labelText: 'Nome'),
                items: opcoesPlantas.map((planta) {
                  return DropdownMenuItem(
                    value: planta,
                    child: Text(planta, style: const TextStyle(color: Color(0xFF096591))),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _nomeSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Selecione uma planta';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _localizacaoController,
                decoration: const InputDecoration(labelText: 'Localização'),
                style: const TextStyle(color: Color(0xFF096591)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF096591)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final planta = {
                      'nome': _nomeSelecionado!,
                      'localizacao': _localizacaoController.text,
                    };
                    Navigator.pop(context, planta);
                  }
                },
                child: const Text('OK', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}