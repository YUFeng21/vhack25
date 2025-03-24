import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../widgets/base_layout.dart';
import '../providers/plant_provider.dart';
import '../providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart'; // Import kIsWeb
import 'dart:convert'; // Import base64Decode
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage; // Variable to store the selected image

  @override
  void initState() {
    super.initState();
    // Remove the automatic call to getFarmData
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     final plantProvider = Provider.of<PlantProvider>(context, listen: false);
    //     await plantProvider.getFarmData();
    // });
  }

  @override
  void dispose() {
    _messageController.dispose(); // Prevent memory leaks
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildMessageBubble(Message message) {
    final isUser = message.role == 'user';
    final timeStr = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? Colors.green.shade100 : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: isUser ? Radius.circular(20) : Radius.circular(5),
            bottomRight: isUser ? Radius.circular(5) : Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (message.imageUrl != null) // Check if there's an image URL
                kIsWeb
                    ? Image.memory(base64Decode(message.imageUrl!), fit: BoxFit.cover) // Use Image.memory for base64
                    : Image.file(File(message.imageUrl!), fit: BoxFit.cover), // Use Image.file for local files
              Text(
                message.content,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 4),
              Text(
                timeStr,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask about plants...',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: () async {
              final pickedFile = await _picker.pickImage(
                source: ImageSource.gallery,
                imageQuality: 100,
              );

              if (pickedFile != null) {
                setState(() {
                  _selectedImage = pickedFile; // Store the selected image
                });
                await _sendImageMessage(_selectedImage!, _messageController.text.trim()); // Pass the message content
              }
            },
            tooltip: 'Upload Image',
          ),
          Consumer<PlantProvider>(
            builder: (context, plantProvider, child) {
              return IconButton(
                icon: Icon(Icons.send_rounded),
                onPressed: () async {
                  if (_messageController.text.trim().isNotEmpty) {
                    final userId = Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).user.username;
                    print('User ID: $userId'); // Debugging line

                    await plantProvider.sendTextMessage(
                      userId,
                      _messageController.text.trim(),
                    );

                    _messageController.clear();
                    _scrollToBottom();
                  }
                },
                tooltip: 'Send Message',
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _sendImageMessage(XFile imageFile, String message) async {
    final userId = Provider.of<UserProvider>(context, listen: false).user?.username;
    final plantProvider = Provider.of<PlantProvider>(context, listen: false);

    if (userId == null) {
      print('User ID is null. Cannot send image message.');
      return; // Early return if userId is null
    }

    try {
      // Add the image message to the local messages list
      plantProvider.messages.add(Message(
        role: 'user',
        content: message, // Pass the actual message content
        imageUrl: kIsWeb ? base64Encode(await imageFile.readAsBytes()) : imageFile.path,
        timestamp: DateTime.now(),
      ));
      plantProvider.notifyListeners(); // Notify listeners to update the UI

      // Send the image message
      await plantProvider.sendImageMessage(userId, message, imageFile); // Pass the message content
    } catch (e) {
      print('Error sending image message: $e');
      // Optionally, show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 1,
      child: Container(
        color: Colors.grey.shade100,
        child: Column(
          children: [
            Expanded(
              child: Consumer<PlantProvider>(
                builder: (context, plantProvider, child) {
                  if (plantProvider.messages.isEmpty) {
                    return Center(
                      child: Text('Start a conversation about plants!'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: plantProvider.messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(plantProvider.messages[index]);
                    },
                  );
                },
              ),
            ),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }
} 