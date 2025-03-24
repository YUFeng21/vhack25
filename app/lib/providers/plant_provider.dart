import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart'; // Ensure you have image_picker installed
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:http_parser/http_parser.dart'; // ✅ Import MediaType
import 'package:path/path.dart' as path;


class Message {
  final String role;
  String content;
  final String? imageUrl;
  final DateTime timestamp;

  Message({
    required this.role,
    required this.content,
    this.imageUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class FarmData {
  final String typePlant;
  final String environment;
  final String suitableSoil;
  final String wateringAmount;

  FarmData({
    required this.typePlant,
    required this.environment,
    required this.suitableSoil,
    required this.wateringAmount,
  });

  factory FarmData.fromJson(Map<String, dynamic> json) {
    return FarmData(
      typePlant: json['type_plant'] ?? 'N/A',
      environment: json['environment'] ?? 'N/A',
      suitableSoil: json['suitable_soil'] ?? 'N/A',
      wateringAmount: json['watering_amount'] ?? 'N/A',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type_plant': typePlant,
      'environment': environment,
      'suitable_soil': suitableSoil,
      'watering_amount': wateringAmount,
    };
  }
}

class PlantProvider with ChangeNotifier {
  // Directly set baseUrl to localhost:3000
  final String baseUrl = 'http://localhost:3000';
  final String apiKey = dotenv.env['JAMAI_API_KEY'] ?? '';
  final String projectId = dotenv.env['JAMAI_PROJECT_ID'] ?? '';
  
  // Chat-related state
  final List<Message> _messages = [];
  bool _isLoading = false;
  StreamSubscription? _streamSubscription;
  String _currentStreamingMessage = '';
  
  // Farm data state
  List<FarmData> _farmData = [];
  String? _error;

  // Getters
  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  List<FarmData> get farmData => _farmData;
  String? get error => _error;

  // Chat Methods
  Future<void> sendTextMessage(String userId, String message) async {
    _isLoading = true;
    _currentStreamingMessage = '';
    notifyListeners();

    try {
        // Add the user's message to the chat
        _messages.add(Message(
            role: 'user',
            content: message,
        ));
        notifyListeners();

        final tempMessage = Message(
            role: 'assistant',
            content: '',
        );
        _messages.add(tempMessage);
        notifyListeners();

        final request = http.Request('POST', Uri.parse('$baseUrl/chat'));
        request.headers['Content-Type'] = 'application/json';
        request.body = json.encode({
            'message': message,
        });

        final client = http.Client();
        final streamedResponse = await client.send(request);

        if (streamedResponse.statusCode != 200) {
            final errorBody = await streamedResponse.stream.bytesToString();
            print('Error response body: $errorBody');
            throw Exception('Server returned ${streamedResponse.statusCode}: $errorBody');
        }

        // Handle the streamed response
        _handleStreamResponse(streamedResponse, tempMessage);

    } catch (e) {
        print('Error sending message: $e');
        _messages.add(Message(
            role: 'assistant',
            content: 'Sorry, there was an error. Please try again.',
        ));
        _isLoading = false;
        notifyListeners();
    }
  }

Future<void> sendImageMessage(String userId, String message, XFile imageFile) async {
  _isLoading = true;
  _currentStreamingMessage = '';
  notifyListeners();

  try {
    String mimeType = getMimeType(imageFile.path); // Get the MIME type
    // Read image as bytes
    Uint8List imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes); // Convert to base64

    // Log the request body
    print('Sending request with body: ${json.encode({
      'userId': userId,
      'message': message,
      'image': {
        'mimeType': mimeType,
      },
    })}');

    var request = http.Request('POST', Uri.parse('$baseUrl/chat'));
    request.headers['Content-Type'] = 'application/json';
    request.body = json.encode({
      'userId': userId,
      'message': message,
      'image': {
        'data': base64Image,
        'mimeType': mimeType,
      },
    });

    final client = http.Client();
    final streamedResponse = await client.send(request);

    if (streamedResponse.statusCode != 200) {
      final errorBody = await streamedResponse.stream.bytesToString();
      print('Error response body: $errorBody');
      throw Exception('Server returned ${streamedResponse.statusCode}: $errorBody');
    }

    // Add the image message to the chat
    _messages.add(Message(
      role: 'user',
      content: message.isNotEmpty ? message : '', // Use the message if provided
      imageUrl: base64Image, // Store the base64 string instead of the file path
      timestamp: DateTime.now(),
    ));
    notifyListeners();

    // Handle the streamed response
    _handleStreamResponse(streamedResponse, Message(
      role: 'assistant',
      content: '',
      imageUrl: null,
      timestamp: DateTime.now(),
    ));

  } catch (e) {
    print('Error sending image and message: $e');
    _messages.add(Message(
      role: 'assistant',
      content: 'Sorry, there was an error. Please try again.',
      imageUrl: null,
      timestamp: DateTime.now(),
    ));
    _isLoading = false;
    notifyListeners();
  }
}

  void _handleStreamResponse(http.StreamedResponse streamedResponse, Message tempMessage) {
    _streamSubscription = streamedResponse.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
      (data) {
        if (data.startsWith('data: ')) {
          try {
            // Strip the 'data: ' prefix before parsing
            final jsonData = json.decode(data.substring(6)); // Start from index 6 to skip 'data: '
            if (jsonData['results'] != null) {
              final results = jsonData['results'];
              // Update the message with the fetched data
              tempMessage.content = "Plant Type: ${results['plant_type']}, Environment: ${results['environment']}, Suitable Soil: ${results['suitable_soil']}, Watering Amount: ${results['watering_amount']}";
              notifyListeners();
            } else if (jsonData['message'] != null) {
              // Handle the success message
              tempMessage.content = jsonData['message']; // Display the success message
              notifyListeners();
            } else if (jsonData['error'] != null) {
              print('Stream error: ${jsonData['error']}');
              tempMessage.content = 'Error: ${jsonData['error']}';
              notifyListeners();
            }
          } catch (e) {
            print('Error parsing stream data: $e');
          }
        }
      },
      onError: (error) {
        print('Stream error: $error');
        tempMessage.content = 'Error: Failed to receive response. Please try again.';
        notifyListeners();
      },
      onDone: () {
        print('Stream completed');
        _streamSubscription?.cancel();
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Farm Data Methods
  Future<void> getFarmData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
        final response = await http.get(Uri.parse('$baseUrl/get-farm-data'));

        // Log the response for debugging
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            // Get the latest entry (assuming the latest is the last item)
            if (data.isNotEmpty) {
                _farmData = [FarmData.fromJson(data.first)]; // Only keep the latest entry
                // Optionally, you can also store the latest message
                final latestMessage = "Latest Farm Data:\nType of Plant: ${data.first['type_plant']}\nEnvironment: ${data.first['environment']}\nSuitable Soil: ${data.first['suitable_soil']}\nWatering Amount: ${data.first['watering_amount']}";
                _messages.add(Message(role: 'assistant', content: latestMessage)); // Add to messages
            } else {
                _farmData = []; // No data case
            }
            print('✅ Latest farm data retrieved successfully');
        } else {
            _error = 'Failed to retrieve farm data: ${response.statusCode}';
            print('❌ Error retrieving farm data: ${response.body}');
            throw Exception(_error);
        }
    } catch (e) {
        _error = 'Error: $e';
        print('❌ Error: $e');
        rethrow;
    } finally {
        _isLoading = false;
        notifyListeners();
    }
  }

  Future<void> fetchData(String question) async {
    try {
        final response = await http.get(Uri.parse('$baseUrl/get-farm-data?question=$question'));

        if (response.statusCode == 200) {
            final List<dynamic> data = jsonDecode(response.body);
            _farmData = data.map((json) => FarmData.fromJson(json)).toList();
            print('✅ Farm data retrieved successfully');
        } else {
            _error = 'Failed to retrieve farm data: ${response.statusCode}';
            print('❌ Error retrieving farm data: ${response.body}');
            throw Exception(_error);
        }
    } catch (e) {
        _error = 'Error: $e';
        print('❌ Error: $e');
        rethrow;
    } finally {
        _isLoading = false;
        notifyListeners();
    }
  }

  // Utility Methods
  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  String getMimeType(String filePath) {
    String extension = path.extension(filePath).toLowerCase();
    
    switch (extension) {
      case '.png':
        return 'image/png';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      default:
        return 'application/octet-stream'; // Fallback for unsupported formats
    }
  }
}