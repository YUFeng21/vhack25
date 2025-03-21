import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/mqtt_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => MqttService()..connect(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqttService = Provider.of<MqttService>(context);

    return Scaffold(
      appBar: AppBar(title: Text("IoT Farm Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SensorCard("🌡 Temperature", "${mqttService.temperature} °C", Colors.orange),
            SensorCard("💧 Humidity", "${mqttService.humidity} %", Colors.blue),
            SensorCard("☀️ Light Intensity", "${mqttService.lightIntensity}", Colors.yellow),
            SensorCard("🌱 Soil Moisture", "${mqttService.soilMoisture} %", Colors.green),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  SensorCard(this.title, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.2),
      child: ListTile(
        leading: Icon(Icons.sensor_window, color: color),
        title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
