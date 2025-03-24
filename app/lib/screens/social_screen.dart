//social_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/post.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final TextEditingController _postController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
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
    final postProvider = Provider.of<PostProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Social Feed')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: postProvider.posts.length,
                itemBuilder: (context, index) {
                  final post = postProvider.posts[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                post.username,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              if (post.username == userProvider.user.username)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        _postController.text = post.content;
                                        showDialog(
                                          context: context,
                                          builder:
                                              (context) => AlertDialog(
                                                title: Text('Edit Post'),
                                                content: TextField(
                                                  controller: _postController,
                                                  decoration: InputDecoration(
                                                    labelText: 'Post Content',
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      postProvider.editPost(
                                                        index,
                                                        _postController.text,
                                                      );
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    },
                                                    child: Text('Save'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        postProvider.deletePost(index);
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          if (post.imageUrl != null)
                            kIsWeb
                                ? Image.network(post.imageUrl!)
                                : Image.file(File(post.imageUrl!)),
                          Text(post.content),
                          SizedBox(height: 8.0),
                          Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.thumb_up),
                                onPressed: () {
                                  postProvider.likePost(index);
                                },
                              ),
                              Text('${post.likes} likes'),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: InputDecoration(
                                    labelText: 'Add a comment',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.send),
                                onPressed: () {
                                  postProvider.addComment(
                                    index,
                                    userProvider.user.username,
                                    _commentController.text,
                                  );
                                  _commentController.clear();
                                },
                              ),
                            ],
                          ),
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
                    controller: _postController,
                    decoration: InputDecoration(labelText: 'Create a post'),
                  ),
                ),
                IconButton(icon: Icon(Icons.image), onPressed: _pickImage),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Create a new Post object
                    final newPost = Post(
                      username: userProvider.user.username,
                      content: _postController.text,
                      timestamp: DateTime.now(),
                      imageUrl: _imageUrl, // Assuming your Post class has an imageUrl field
                    );

                    // Add the new post using the provider
                    postProvider.addPost(newPost);

                    // Clear the text field and reset the image URL
                    _postController.clear();
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
