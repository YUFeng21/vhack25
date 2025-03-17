#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

// Function Prototypes (Fixes the "not declared" errors)
void reconnectMQTT();
void readAndSendData();

// WiFi & MQTT Credentials
const char* ssid = "Your-WiFi-SSID";  // Replace with your WiFi name
const char* password = "Your-WiFi-Password";  // Replace with your WiFi password
const char* mqttServer = "broker.hivemq.com";  // Public MQTT broker
const int mqttPort = 1883;
const char* mqttTopic = "farm/sensors";  // MQTT topic

// Sensor Pins
#define DHT_PIN 4
#define DHT_TYPE DHT22
#define LDR_PIN 34
#define SOIL_MOISTURE_PIN 35
#define BUZZER_PIN 5

// Objects
WiFiClient espClient;
PubSubClient client(espClient);
DHT dht(DHT_PIN, DHT_TYPE);

// Variables
unsigned long lastReadTime = 0;
const int readInterval = 5000;  // Read every 5 seconds
bool buzzerOn = false;
unsigned long buzzerStartTime = 0;

void setup() {
    Serial.begin(115200);

    // Connect to WiFi
    WiFi.begin(ssid, password);
    Serial.print("Connecting to WiFi...");
    while (WiFi.status() != WL_CONNECTED) {
        delay(1000);
        Serial.print(".");
    }
    Serial.println("\nConnected to WiFi");

    // Connect to MQTT Broker
    client.setServer(mqttServer, mqttPort);
    reconnectMQTT();  // No longer causes error

    // Initialize sensors
    dht.begin();
    pinMode(BUZZER_PIN, OUTPUT);
    digitalWrite(BUZZER_PIN, LOW);
}

void loop() {
    if (!client.connected()) {
        reconnectMQTT();  // No longer causes error
    }
    client.loop();

    // Read sensor data at intervals
    if (millis() - lastReadTime >= readInterval) {
        lastReadTime = millis();
        readAndSendData();  // No longer causes error
    }

    // Handle buzzer timing (non-blocking)
    if (buzzerOn && millis() - buzzerStartTime >= 1000) {
        digitalWrite(BUZZER_PIN, LOW);
        buzzerOn = false;
    }
}

void readAndSendData() {
    float temperature = dht.readTemperature();
    float humidity = dht.readHumidity();
    int lightIntensity = analogRead(LDR_PIN);
    int soilMoisture = analogRead(SOIL_MOISTURE_PIN);

    if (isnan(temperature) || isnan(humidity)) {
        Serial.println("DHT sensor error! Skipping this reading...");
        return;
    }

    int soilMoisturePercent = map(soilMoisture, 4095, 0, 0, 100);

    Serial.print("Temp: "); Serial.print(temperature); Serial.print("°C, ");
    Serial.print("Humidity: "); Serial.print(humidity); Serial.print("%, ");
    Serial.print("Light: "); Serial.print(lightIntensity); Serial.print(", ");
    Serial.print("Soil Moisture: "); Serial.print(soilMoisturePercent); Serial.println("%");

    String payload = "{";
    payload += "\"temperature\":" + String(temperature) + ",";
    payload += "\"humidity\":" + String(humidity) + ",";
    payload += "\"lightIntensity\":" + String(lightIntensity) + ",";
    payload += "\"soilMoisture\":" + String(soilMoisturePercent);
    payload += "}";

    client.publish(mqttTopic, payload.c_str());

    if (soilMoisturePercent < 30) {
        digitalWrite(BUZZER_PIN, HIGH);
        buzzerOn = true;
        buzzerStartTime = millis();
    }
}

void reconnectMQTT() {
    while (!client.connected()) {
        Serial.print("Connecting to MQTT...");
        if (client.connect("ESP32Client")) {
            Serial.println("Connected to MQTT broker!");
        } else {
            Serial.print("Failed, retrying in 5s...");
            delay(5000);
        }
    }
}
