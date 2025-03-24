//post_provider.dart
import 'package:flutter/material.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => _posts;

  void addPost(String username, String content, {String? imageUrl}) {
    _posts.add(Post(username: username, content: content, imageUrl: imageUrl));
    notifyListeners();
  }

  void editPost(int index, String content) {
    _posts[index].content = content;
    notifyListeners();
  }

  void deletePost(int index) {
    _posts.removeAt(index);
    notifyListeners();
  }

  void likePost(int index) {
    _posts[index].likes++;
    notifyListeners();
  }

  void addComment(int index, String username, String content) {
    _posts[index].comments.add(Comment(username: username, content: content));
    notifyListeners();
  }

  void deleteComment(int postIndex, int commentIndex) {
    _posts[postIndex].comments.removeAt(commentIndex);
    notifyListeners();
  }
}
