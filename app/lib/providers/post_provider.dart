import 'package:flutter/material.dart';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [];

  List<Post> get posts => List.unmodifiable(_posts);

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void likePost(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      _posts[index] = Post(
        username: post.username,
        content: post.content,
        timestamp: post.timestamp,
        imageUrl: post.imageUrl,
        likes: post.likes + 1,
        comments: post.comments,
      );
      notifyListeners();
    }
  }

  void deletePost(int index) {
    if (index >= 0 && index < _posts.length) {
      _posts.removeAt(index);
      notifyListeners();
    }
  }

  void editPost(int index, String newContent) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      _posts[index] = Post(
        username: post.username,
        content: newContent,
        timestamp: post.timestamp,
        imageUrl: post.imageUrl,
        likes: post.likes,
        comments: post.comments,
      );
      notifyListeners();
    }
  }

  void addComment(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      _posts[index] = Post(
        username: post.username,
        content: post.content,
        timestamp: post.timestamp,
        imageUrl: post.imageUrl,
        likes: post.likes,
        comments: post.comments + 1,
      );
      notifyListeners();
    }
  }

  void removeComment(int index) {
    if (index >= 0 && index < _posts.length) {
      final post = _posts[index];
      if (post.comments > 0) {
        _posts[index] = Post(
          username: post.username,
          content: post.content,
          timestamp: post.timestamp,
          imageUrl: post.imageUrl,
          likes: post.likes,
          comments: post.comments - 1,
        );
        notifyListeners();
      }
    }
  }
}