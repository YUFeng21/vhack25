import 'package:flutter/material.dart';
import 'providers/mqtt_provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final MqttProvider mqttProvider = MqttProvider('broker.hivemq.com', 'flutter_client');

  @override
  Widget build(BuildContext context) {
    mqttProvider.connect();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MQTT with HiveMQ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  mqttProvider.subscribe('test/topic');
                },
                child: Text('Subscribe to Topic'),
              ),
              ElevatedButton(
                onPressed: () {
                  mqttProvider.publish('test/topic', 'Hello from Flutter');
                },
                child: Text('Publish Message'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
