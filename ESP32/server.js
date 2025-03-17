const mqtt = require('mqtt');

// MQTT Broker Connection
const mqttServer = "mqtt://broker.hivemq.com";
const client = mqtt.connect(mqttServer);

client.on("connect", () => {
    console.log("Connected to MQTT broker!");
    client.subscribe("farm/sensors");
});

client.on("message", (topic, message) => {
    console.log(`Received Data: ${message.toString()}`);
});
