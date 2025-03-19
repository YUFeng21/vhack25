class Comment {
  String username;
  String content;

  Comment({required this.username, required this.content});
}

class Post {
  final String username;
  final String content;
  final DateTime timestamp;
  final String? imageUrl;
  final int likes;
  final int comments;

  Post({
    required this.username,
    required this.content,
    required this.timestamp,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
  });
}