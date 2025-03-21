import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/mqtt_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MqttProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MqttScreen(),
      ),
    );
  }
}

class MqttScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mqttProvider = Provider.of<MqttProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('MQTT Data')),
      body: Center(
        child: Text(
          mqttProvider.receivedMessage,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
