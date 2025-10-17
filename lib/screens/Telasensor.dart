import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:convert';
import 'dart:async'; // Necessário para o Timer se a conexão falhar

// Definições de Tópicos (Ajuste conforme a sua ESP32)
const String MQTT_TOPIC_DATA = 'regador/data';
const String MQTT_TOPIC_BOMBA_CMD = 'regador/bomba/cmd';
const String MQTT_TOPIC_BOMBA_STATUS = 'regador/bomba/status';

// A classe foi renomeada para Telasensor, mantendo a convenção PascalCase
class Telasensor extends StatefulWidget {
  const Telasensor({super.key});

  @override
  State<Telasensor> createState() => _TelasensorState();
}

class _TelasensorState extends State<Telasensor> {
  // CLIENTE MQTT
  final MqttServerClient client = MqttServerClient('192.168.1.104', 'flutterClient');
  
  // DADOS DE ESTADO
  String _statusConexao = 'Desconectado';
  String _umidadeSolo = "--- %";
  String _temperatura = "--- °C";
  String _statusBomba = "Desligada";
  
  // Variável de controle para o botão da bomba (true = ligada)
  bool _bombaLigada = false;

  @override
  void initState() {
    super.initState();
    _connect();
  }
  
  // Função de Conexão MQTT
  Future<void> _connect() async {
    // Configurações do Cliente MQTT
    client.port = 1883; // Ajuste para 8883 se usar TLS
    client.logging(on: false); // Melhor desabilitar logs excessivos em produção
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.secure = false; 
    client.setProtocolV311();

    // Mensagem de Conexão
    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier('flutterClient_${DateTime.now().millisecondsSinceEpoch}')
        ;

    // TENTA CONECTAR
    try {
      setState(() => _statusConexao = 'Conectando...');
      await client.connect();
    } catch (e) {
      print('Erro de Conexão MQTT: $e');
      client.disconnect();
    }

    // VERIFICA STATUS DA CONEXÃO
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT Conectado com sucesso!');
      setState(() => _statusConexao = 'Conectado');
      
      // SUBSCREVE NOS TÓPICOS DE DADOS E STATUS DA BOMBA
      client.subscribe(MQTT_TOPIC_DATA, MqttQos.atMostOnce);
      client.subscribe(MQTT_TOPIC_BOMBA_STATUS, MqttQos.atMostOnce);

      // ESCUTA POR ATUALIZAÇÕES
      client.updates!.listen(_onMessageReceived);
    } else {
      print('Falha na conexão MQTT. Tentando novamente em 5s.');
      setState(() => _statusConexao = 'Falha na Conexão');
      // Tenta reconectar após um atraso
      Timer(const Duration(seconds: 5), _connect);
    }
  }

  // Tratamento de Mensagens Recebidas
  void _onMessageReceived(List<MqttReceivedMessage<MqttMessage?>>? c) {
    if (c == null || c.isEmpty) return;

    final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
    final String topic = c[0].topic;
    final String payload = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('Mensagem recebida do tópico: $topic');
    print('Conteúdo: $payload');

    if (topic == MQTT_TOPIC_DATA) {
      _processSensorData(payload);
    } else if (topic == MQTT_TOPIC_BOMBA_STATUS) {
      _processPumpStatus(payload);
    }
  }

  // Decodifica JSON do Sensor
  void _processSensorData(String payload) {
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      setState(() {
        _umidadeSolo = data['umidade'] != null ? '${data['umidade'].toString()} %' : _umidadeSolo;
        _temperatura = data['temperatura'] != null ? '${data['temperatura'].toString()} °C' : _temperatura;
      });
    } catch (e) {
      print('Erro ao decodificar JSON dos dados do sensor: $e');
    }
  }

  // Processa Status da Bomba
  void _processPumpStatus(String payload) {
    setState(() {
      // Assumindo que a ESP32 envia 'ON' ou 'OFF'
      if (payload.toUpperCase() == 'ON') {
        _statusBomba = 'Ligada';
        _bombaLigada = true;
      } else if (payload.toUpperCase() == 'OFF') {
        _statusBomba = 'Desligada';
        _bombaLigada = false;
      }
    });
  }

  // Publica Comando da Bomba
  void _publishBombaCommand(bool turnOn) {
    if (client.connectionStatus!.state != MqttConnectionState.connected) {
      print('Cliente MQTT não está conectado para publicar.');
      return;
    }

    final builder = MqttClientPayloadBuilder();
    final command = turnOn ? 'LIGAR' : 'DESLIGAR';
    builder.addString(command);
    
    client.publishMessage(
      MQTT_TOPIC_BOMBA_CMD,
      MqttQos.atMostOnce,
      builder.payload!,
    );
    print('Comando enviado para $MQTT_TOPIC_BOMBA_CMD: $command');
  }

  void _onDisconnected() {
    print('MQTT desconectado!');
    setState(() => _statusConexao = 'Desconectado');
    // Tenta reconectar
    Timer(const Duration(seconds: 5), _connect);
  }

  @override
  void dispose() {
    client.disconnect();
    super.dispose();
  }

  // UI Components
  Widget _buildSensorCard(String title, String value) {
    return Card(
      color: Colors.white10,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Regador Automático'),
        centerTitle: true,
        actions: [
           Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  _statusConexao == 'Conectado' ? Icons.check_circle : Icons.warning,
                  color: _statusConexao == 'Conectado' ? Colors.greenAccent : Colors.yellowAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _statusConexao,
                  style: TextStyle(fontSize: 14, color: _statusConexao == 'Conectado' ? Colors.greenAccent : Colors.yellowAccent),
                ),
              ],
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildSensorCard("Umidade do Solo", _umidadeSolo),
            const SizedBox(height: 16),

            _buildSensorCard("Temperatura do Ar", _temperatura),
            const SizedBox(height: 30),

            // Cartão de Controle da Bomba
            Card(
              color: _bombaLigada ? Colors.green.shade700 : Colors.red.shade700,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      "Controle Manual da Bomba",
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Status: $_statusBomba',
                      style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Inverte o estado e publica o comando
                        _publishBombaCommand(!_bombaLigada);
                      },
                      icon: Icon(
                        _bombaLigada ? Icons.power_settings_new : Icons.power_off, 
                        color: Colors.black
                      ),
                      label: Text(
                        _bombaLigada ? "DESLIGAR MANUALMENTE" : "LIGAR MANUALMENTE",
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
