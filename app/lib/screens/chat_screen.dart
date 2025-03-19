import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import '../widgets/base_layout.dart';
import '../providers/ai_provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _imageFile;
  Uint8List? _webImage;
  bool _showImagePreview = false;
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context, listen: false).user.username;
      Provider.of<AIProvider>(context, listen: false).loadChatHistory(userId);
    });
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _webImage = bytes;
          _imageFile = 'data:image/jpeg;base64,${base64Encode(bytes)}';
          _showImagePreview = true;
        });
      } else {
        setState(() {
          _imageFile = pickedFile.path;
          _showImagePreview = true;
        });
      }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: _buildImageWidget(message.imageUrl!),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
          ],
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imagePath) {
    if (kIsWeb) {
      if (imagePath.startsWith('data:image')) {
        final base64Str = imagePath.split(',')[1];
        return Image.memory(
          base64Decode(base64Str),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorContainer();
          },
        );
      } else {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorContainer();
          },
        );
      }
    } else {
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorContainer();
        },
      );
    }
  }

  Widget _buildErrorContainer() {
    return Container(
      height: 150,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 32),
          SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.red[700]),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewImage() {
    if (kIsWeb && _webImage != null) {
      return Image.memory(
        _webImage!,
        fit: BoxFit.cover,
      );
    } else if (!kIsWeb && _imageFile != null) {
      return Image.file(
        File(_imageFile!),
        fit: BoxFit.cover,
      );
    }
    return _buildErrorContainer();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showImagePreview && (_imageFile != null || _webImage != null))
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: _buildPreviewImage(),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _imageFile = null;
                          _webImage = null;
                          _showImagePreview = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  icon: Icon(Icons.image_outlined, color: Colors.green),
                  onPressed: _pickImage,
                  tooltip: 'Add Image',
                ),
              ),
              SizedBox(width: 8),
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
              Consumer<AIProvider>(
                builder: (context, aiProvider, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: aiProvider.isLoading ? Colors.grey.shade300 : Colors.green.shade50,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.send_rounded,
                        color: aiProvider.isLoading ? Colors.grey : Colors.green,
                      ),
                      onPressed: aiProvider.isLoading
                          ? null
                          : () async {
                              if (_messageController.text.trim().isEmpty &&
                                  _imageFile == null) {
                                return;
                              }

                              final userId = Provider.of<UserProvider>(
                                context,
                                listen: false,
                              ).user.username;

                              if (_imageFile != null) {
                                await aiProvider.sendImageMessage(
                                  userId,
                                  _imageFile!,
                                  _messageController.text.trim(),
                                );
                                setState(() {
                                  _imageFile = null;
                                  _webImage = null;
                                  _showImagePreview = false;
                                });
                              } else {
                                await aiProvider.sendTextMessage(
                                  userId,
                                  _messageController.text.trim(),
                                );
                              }

                              _messageController.clear();
                              _scrollToBottom();
                            },
                      tooltip: 'Send Message',
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
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
              child: Consumer<AIProvider>(
                builder: (context, aiProvider, child) {
                  if (aiProvider.messages.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline,
                              size: 64,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Start a conversation about plants!',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ask questions or share plant images',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        itemCount: aiProvider.messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(aiProvider.messages[index]);
                        },
                      ),
                      if (aiProvider.isLoading)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'AI is thinking...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
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