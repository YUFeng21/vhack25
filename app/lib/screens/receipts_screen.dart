import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/base_layout.dart';
import '../providers/ai_provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  _ReceiptsScreenState createState() => _ReceiptsScreenState();
}

class _ReceiptsScreenState extends State<ReceiptsScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? _imageUrl;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = Provider.of<AIProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return BaseLayout(
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: aiProvider.messages.length,
                itemBuilder: (context, index) {
                  final message = aiProvider.messages[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(message.sender, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.0),
                          if (message.imageUrl != null)
                            kIsWeb
                                ? Image.network(message.imageUrl!)
                                : Image.file(File(message.imageUrl!)),
                          Text(message.content),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    aiProvider.sendMessage(userProvider.user.username, _messageController.text, imageUrl: _imageUrl);
                    _messageController.clear();
                    setState(() {
                      _imageUrl = null;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}