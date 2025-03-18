class Comment {
  String username;
  String content;

  Comment({required this.username, required this.content});
}

class Post {
  String username;
  String content;
  String? imageUrl;
  int likes;
  List<Comment> comments;

  Post({
    required this.username,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    List<Comment>? comments,
  }) : comments = comments ?? [];
}