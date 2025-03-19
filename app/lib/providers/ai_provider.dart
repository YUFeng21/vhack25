import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class Message {
  final String role;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;

  Message({
    required this.role,
    required this.content,
    this.imageUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIProvider with ChangeNotifier {
  final List<Message> _messages = [];
  final String baseUrl = 'http://localhost:3000';
  bool _isLoading = false;

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;

  // Send a text message
  Future<void> sendTextMessage(String userId, String message) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages.add(Message(
        role: 'user',
        content: message,
      ));
      notifyListeners();

      final response = await http.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _messages.add(Message(
          role: 'assistant',
          content: jsonResponse['response'],
        ));
      } else {
        _messages.add(Message(
          role: 'assistant',
          content: 'Sorry, I encountered an error. Please try again.',
        ));
      }
    } catch (e) {
      _messages.add(Message(
        role: 'assistant',
        content: 'Sorry, there was a network error. Please check your connection.',
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Send an image with optional question
  Future<void> sendImageMessage(String userId, String imagePath, String question) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages.add(Message(
        role: 'user',
        content: question,
        imageUrl: imagePath,
      ));
      notifyListeners();

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/analyze-plant'));
      request.fields['userId'] = userId;
      request.fields['question'] = question;

      if (kIsWeb) {
        if (imagePath.startsWith('data:image')) {
          // Handle base64 image
          final base64Data = imagePath.split(',')[1];
          final bytes = base64Decode(base64Data);
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: 'image.jpg',
            ),
          );
        } else {
          // Handle network image
          final response = await http.get(Uri.parse(imagePath));
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              response.bodyBytes,
              filename: 'image.jpg',
            ),
          );
        }
      } else {
        // For mobile platforms
        request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _messages.add(Message(
          role: 'assistant',
          content: jsonResponse['response'],
        ));
      } else {
        _messages.add(Message(
          role: 'assistant',
          content: 'Sorry, I encountered an error analyzing the image. Please try again.',
        ));
      }
    } catch (e) {
      print('Error sending image: $e');
      _messages.add(Message(
        role: 'assistant',
        content: 'Sorry, there was an error processing your image. Please try again.',
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load chat history
  Future<void> loadChatHistory(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/chat-history/$userId'));

      if (response.statusCode == 200) {
        final List<dynamic> history = json.decode(response.body);
        _messages.clear();
        _messages.addAll(history.map((msg) => Message(
          role: msg['role'],
          content: msg['content'],
          timestamp: DateTime.parse(msg['timestamp']),
        )));
      }
    } catch (e) {
      print('Error loading chat history: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }
}