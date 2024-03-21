class Blog {
  final String id;
  final String user_id;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String? userName;

  Blog({
    required this.id,
    required this.user_id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.userName,
  });
}
