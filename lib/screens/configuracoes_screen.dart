import 'package:flutter/material.dart';
// Para sair, se necessário

class TelaConfiguracoes extends StatefulWidget {
  const TelaConfiguracoes({super.key});

  @override
  State<TelaConfiguracoes> createState() => _TelaConfiguracoesState();
}

class _TelaConfiguracoesState extends State<TelaConfiguracoes> {
  bool modoEscuro = false; // Exemplo de toggle
  bool backupAtivado = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          // Modo Escuro
          SwitchListTile(
            title: const Text('Modo Escuro', style: TextStyle(color: Colors.white)),
            secondary: const Icon(Icons.dark_mode, color: Colors.white),
            value: modoEscuro,
            onChanged: (bool value) {
              setState(() {
                modoEscuro = value;
                // Aqui você pode adicionar lógica real para alternar tema
              });
            },
          ),
          // Backup
          SwitchListTile(
            title: const Text('Backup', style: TextStyle(color: Colors.white)),
            secondary: const Icon(Icons.backup, color: Colors.white),
            value: backupAtivado,
            onChanged: (bool value) {
              setState(() {
                backupAtivado = value;
                // Aqui você pode adicionar lógica real de backup
              });
            },
          ),
          // Aplicativo Web
          ListTile(
            leading: const Icon(Icons.web, color: Colors.white),
            title: const Text('Aplicativo Web', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Abrir link do app web
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo aplicativo web...')),
              );
            },
          ),
          // Escreva uma avaliação
          ListTile(
            leading: const Icon(Icons.rate_review, color: Colors.white),
            title: const Text('Escreva uma avaliação', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Abrir link para avaliação
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo avaliação...')),
              );
            },
          ),
          // Contate-nos
          ListTile(
            leading: const Icon(Icons.contact_mail, color: Colors.white),
            title: const Text('Contate-nos', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Abrir email ou formulário
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo contato...')),
              );
            },
          ),
          // Torne-se um testador
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.white),
            title: const Text('Torne-se um testador', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Abrir link de teste beta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Abrindo cadastro de testador...')),
              );
            },
          ),
          // Sobre
          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text('Sobre', style: TextStyle(color: Colors.white)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF015A84), // fundo azul
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: const Text(
                    'Regador Automático',
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    'Versão 1.0.0\n2025.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Fechar', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),

        ],
      ),
    );
  }
}
