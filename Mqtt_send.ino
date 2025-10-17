#include <WiFi.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>

// --- CONFIGURAÇÕES DE REDE ---
const char* ssid = "brisa-3117879";         // Nome da sua rede Wi-Fi
const char* password = "9urubuco";    // Senha da sua rede Wi-Fi

// --- CONFIGURAÇÕES MQTT (Devem corresponder ao Telasensor.dart) ---
const char* mqtt_server = "192.168.1.104";    // IP do seu Mosquitto Broker
const int mqtt_port = 1883;                 // Porta padrão do Mosquitto
const char* client_id = "ESP32_Regador";    // ID único para a ESP32

// --- TÓPICOS MQTT ---
const char* TOPIC_DATA = "regador/data";            // Publica Umidade e Temperatura
const char* TOPIC_CMD = "regador/bomba/cmd";        // Recebe comandos (LIGAR/DESLIGAR)
const char* TOPIC_BOMBA_STATUS = "regador/bomba/status"; // Publica o status da bomba

// --- PINOS E ESTADO ---
const int UMIDADE_PIN = 34; // Exemplo de pino para o sensor de umidade (ADC1)
const int BOMBA_PIN = 2;    // Pino da bomba/relé (Exemplo: D2)

bool bomba_ligada = false;
unsigned long lastMsg = 0;
const long interval = 5000; // Intervalo de envio de dados (5 segundos)

// --- OBJETOS ---
WiFiClient espClient;
PubSubClient client(espClient);

// ====================================================================
// FUNÇÕES DE SETUP E CONEXÃO
// ====================================================================

void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Conectando-se a ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.println("WiFi conectado!");
  Serial.print("IP da ESP32: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop até que a conexão seja reestabelecida
  while (!client.connected()) {
    Serial.print("Tentando conexão MQTT...");
    // Tenta conectar com o ID e sem autenticação
    if (client.connect(client_id)) {
      Serial.println("conectado!");
      
      // Assina o tópico de comando da bomba
      client.subscribe(TOPIC_CMD);
      Serial.print("Assinado ao tópico: ");
      Serial.println(TOPIC_CMD);
      
      // Publica o status inicial da bomba
      publish_bomba_status();
      
    } else {
      Serial.print("falhou, rc=");
      Serial.print(client.state());
      Serial.println(" Tentando novamente em 5 segundos");
      // Espera 5 segundos antes de tentar novamente
      delay(5000);
    }
  }
}
// ====================================================================
// FUNÇÕES DE COMUNICAÇÃO
// ====================================================================

// Funções para simular a leitura do sensor (Mantenha o pino ADC1)
int read_umidade_solo() {
  // Simula a leitura ADC (0-4095) e mapeia para porcentagem (0-100)
  // Nota: Você deve calibrar esses valores para o seu sensor
  int rawValue = analogRead(UMIDADE_PIN);
  // Mapeia o valor de 0 a 4095 para 100% (seco) a 0% (molhado)
  // Exemplo de calibração: 2000 é seco, 1000 é molhado
  int umidade = map(rawValue, 2000, 1000, 0, 100);
  if (umidade < 0) umidade = 0;
  if (umidade > 100) umidade = 100;
  return umidade;
}

float read_temperatura() {
  // Simula a temperatura para teste, pois não temos o sensor real
  return 20.0 + (millis() / 600000.0); // Aumenta 0.1ºC a cada minuto
}

void publish_sensor_data() {
  // 1. Leitura dos dados
  int umidade = read_umidade_solo();
  float temperatura = read_temperatura();
  
  // 2. Cria o objeto JSON
  StaticJsonDocument<128> doc;
  doc["umidade"] = umidade;
  doc["temperatura"] = String(temperatura, 1); // 1 casa decimal

  char output[128];
  serializeJson(doc, output);
  
  // 3. Publica a mensagem
  client.publish(TOPIC_DATA, output);
  Serial.print("Publicado [");
  Serial.print(TOPIC_DATA);
  Serial.print("]: ");
  Serial.println(output);
}

void publish_bomba_status() {
  const char* status = bomba_ligada ? "ON" : "OFF";
  client.publish(TOPIC_BOMBA_STATUS, status);
  Serial.print("Publicado [");
  Serial.print(TOPIC_BOMBA_STATUS);
  Serial.print("]: ");
  Serial.println(status);
}

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Mensagem recebida [");
  Serial.print(topic);
  Serial.print("]: ");
  
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }
  Serial.println(message);

  // Verifica se é o tópico de comando
  if (String(topic) == TOPIC_CMD) {
    if (message == "LIGAR") {
      bomba_ligada = true;
      Serial.println("Comando: Ligar Bomba");
    } else if (message == "DESLIGAR") {
      bomba_ligada = false;
      Serial.println("Comando: Desligar Bomba");
    }

    // Ativa/Desativa o relé
    digitalWrite(BOMBA_PIN, bomba_ligada ? HIGH : LOW);

    // Publica o novo status para atualizar o aplicativo Flutter
    publish_bomba_status();
  }
}

// ====================================================================
// ARDUINO SETUP E LOOP
// ====================================================================

void setup() {
  Serial.begin(115200);
  
  // Configura o pino da bomba como saída
  pinMode(BOMBA_PIN, OUTPUT);
  digitalWrite(BOMBA_PIN, LOW); // Garante que começa desligada
  
  // Conexão Wi-Fi
  setup_wifi();
  
  // Conexão MQTT
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  unsigned long now = millis();
  if (now - lastMsg > interval) {
    lastMsg = now;
    
    // Envia os dados do sensor
    publish_sensor_data();
  }
}
