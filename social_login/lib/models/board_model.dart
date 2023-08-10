import 'package:intl/intl.dart';

class Comment {
  final String author, content;

  Comment({
    required this.author,
    required this.content,
  });

  Comment.fromJson(dynamic json)
      : author = json['author'],
        content = json['content'];

  Map<String, dynamic> toJson() {
    return {
      "author": author,
      "content": content,
    };
  }
}

class BoardModel {
  final String author, title, content, boardId, uid;
  final int likes, views, timestamp;
  final List<Comment> comments;

  BoardModel.fromJson(dynamic json, this.boardId)
      : author = json['author'],
        uid = json['uid'],
        timestamp = json['date'],
        title = json['title'],
        likes = json['likes'],
        views = json['views'],
        content = json['content'],
        comments = (json['comments'] as List<dynamic>?)
                ?.map((item) => Comment.fromJson(item as Map<dynamic, dynamic>))
                .toList() ??
            [];

  BoardModel({
    required this.boardId,
    required this.uid,
    required this.author,
    required this.timestamp,
    required this.title,
    required this.likes,
    required this.content,
    required this.comments,
    required this.views,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": boardId,
      "uid": uid,
      "author": author,
      "date": timestamp == 0 ? {".sv": "timestamp"} : timestamp,
      "title": title,
      "likes": likes,
      "content": content,
      "comments": comments,
      "views": views,
    };
  }

  String getDateTime() {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp)
        .add(const Duration(hours: 9));
    return DateFormat('yy.MM.dd HH:mm').format(dateTime);
  }
}
