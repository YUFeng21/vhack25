import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Message {
  String sender;
  String content;
  String? imageUrl;

  Message({required this.sender, required this.content, this.imageUrl});
}

class AIProvider with ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  Future<void> sendMessage(String username, String content, {String? imageUrl}) async {
    _messages.add(Message(sender: username, content: content, imageUrl: imageUrl));
    notifyListeners();

    try {
      if (imageUrl != null) {
        // Sending image and question to the backend
        var request = http.MultipartRequest('POST', Uri.parse('http://localhost:3000/send-data'));
        request.files.add(await http.MultipartFile.fromPath('image', imageUrl));
        request.fields['question'] = content;
        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        if (response.statusCode == 200) {
          _messages.add(Message(
            sender: 'AI',
            content: 'Type Plant: ${jsonResponse['type_plant']}, Environment: ${jsonResponse['environment']}, Suitable Soil: ${jsonResponse['suitable_soil']}, Watering Amount: ${jsonResponse['watering_amount']}',
            imageUrl: null,
          ));
        } else {
          _messages.add(Message(sender: 'AI', content: 'Error: ${jsonResponse['error']}', imageUrl: null));
        }
      } else {
        // Sending question to the backend
        var response = await http.post(
          Uri.parse('http://localhost:3000/send-data'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'question': content}),
        );
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          _messages.add(Message(
            sender: 'AI',
            content: 'Type Plant: ${jsonResponse['type_plant']}, Environment: ${jsonResponse['environment']}, Suitable Soil: ${jsonResponse['suitable_soil']}, Watering Amount: ${jsonResponse['watering_amount']}',
            imageUrl: null,
          ));
        } else {
          _messages.add(Message(sender: 'AI', content: 'Error: ${response.reasonPhrase}', imageUrl: null));
        }
      }
    } catch (e) {
      _messages.add(Message(sender: 'AI', content: 'Error: $e', imageUrl: null));
    }

    notifyListeners();
  }

  Future<void> fetchData(String tableName) async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost:3000/get-data/$tableName'),
        headers: {'Authorization': 'Bearer YOUR_JAMAI_API_KEY'},
      );
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        // Process the fetched data as needed
      } else {
        _messages.add(Message(sender: 'AI', content: 'Error: ${response.reasonPhrase}', imageUrl: null));
      }
    } catch (e) {
      _messages.add(Message(sender: 'AI', content: 'Error: $e', imageUrl: null));
    }

    notifyListeners();
  }
}