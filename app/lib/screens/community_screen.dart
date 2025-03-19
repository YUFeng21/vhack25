import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/post_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/base_layout.dart';
import '../models/post.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final TextEditingController _postController = TextEditingController();
  String? _imageUrl;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  Widget _buildCreatePost() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _postController,
              decoration: InputDecoration(
                hintText: 'Share your farming experience...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 3,
            ),
            if (_imageUrl != null)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      child: kIsWeb
                          ? Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.error),
                                );
                              },
                            )
                          : Image.file(
                              File(_imageUrl!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: Icon(Icons.error),
                                );
                              },
                            ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _imageUrl = null;
                          });
                        },
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: _pickImage,
                  color: Colors.green,
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    if (_postController.text.isNotEmpty) {
                      final username = Provider.of<UserProvider>(context, listen: false).user.username;
                      Provider.of<PostProvider>(context, listen: false).addPost(
                        Post(
                          username: username,
                          content: _postController.text.trim(),
                          timestamp: DateTime.now(),
                          imageUrl: _imageUrl,
                        ),
                      );
                      _postController.clear();
                      setState(() {
                        _imageUrl = null;
                      });
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Post created successfully!'),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.forum_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No posts yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Be the first to share your farming experience!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      currentIndex: 2,
      child: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCreatePost(),
                SizedBox(height: 16),
                Expanded(
                  child: postProvider.posts.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: postProvider.posts.length,
                          itemBuilder: (context, index) {
                            if (index >= postProvider.posts.length) {
                              return null;
                            }
                            final post = postProvider.posts[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.only(bottom: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.green.shade100,
                                      child: Text(
                                        post.username.isNotEmpty ? post.username[0].toUpperCase() : '?',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    title: Text(post.username),
                                    subtitle: Text(
                                      '${post.timestamp.day}/${post.timestamp.month}/${post.timestamp.year}',
                                    ),
                                    trailing: post.username == Provider.of<UserProvider>(context).user.username
                                        ? PopupMenuButton(
                                            itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('Edit'),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _postController.text = post.content;
                                                    showDialog(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text('Edit Post'),
                                                        content: TextField(
                                                          controller: _postController,
                                                          decoration: InputDecoration(
                                                            hintText: 'Edit your post...',
                                                            border: OutlineInputBorder(
                                                              borderRadius: BorderRadius.circular(12),
                                                            ),
                                                          ),
                                                          maxLines: 3,
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () => Navigator.pop(context),
                                                            child: Text('Cancel'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              if (_postController.text.isNotEmpty) {
                                                                postProvider.editPost(index, _postController.text);
                                                                Navigator.pop(context);
                                                                _postController.clear();
                                                              }
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                              backgroundColor: Colors.green,
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            child: Text('Save'),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              PopupMenuItem(
                                                child: ListTile(
                                                  leading: Icon(Icons.delete, color: Colors.red),
                                                  title: Text('Delete', style: TextStyle(color: Colors.red)),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    postProvider.deletePost(index);
                                                  },
                                                ),
                                              ),
                                            ],
                                          )
                                        : null,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(post.content),
                                  ),
                                  if (post.imageUrl != null)
                                    Container(
                                      height: 200,
                                      width: double.infinity,
                                      child: kIsWeb
                                        ? Image.network(
                                            post.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: Icon(Icons.error),
                                              );
                                            },
                                          )
                                        : Image.file(
                                            File(post.imageUrl!),
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[200],
                                                child: Icon(Icons.error),
                                              );
                                            },
                                          ),
                                    ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        TextButton.icon(
                                          icon: Icon(Icons.thumb_up),
                                          label: Text('${post.likes}'),
                                          onPressed: () => postProvider.likePost(index),
                                        ),
                                        TextButton.icon(
                                          icon: Icon(Icons.comment),
                                          label: Text('${post.comments}'),
                                          onPressed: () => postProvider.addComment(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 