import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final DateTime date;
  final String createdBy;
  final String postImageUrl;
  final String caption;
  final List<String> likes;

  get likeCount => likes.length;

  Post({
    required this.id,
    required this.date,
    required this.createdBy,
    required this.postImageUrl,
    required this.caption,
    required this.likes,
  });

  Post copyWith({
    String? id,
    DateTime? date,
    String? createdBy,
    String? postImageUrl,
    String? caption,
    List<String>? likes,
  }) {
    return Post(
      id: id ?? this.id,
      date: date ?? this.date,
      createdBy: createdBy ?? this.createdBy,
      postImageUrl: postImageUrl ?? this.postImageUrl,
      caption: caption ?? this.caption,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'createdBy': createdBy,
      'postImageUrl': postImageUrl,
      'caption': caption,
      'likes': likes,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      createdBy: map['createdBy'] ?? '',
      postImageUrl: map['postImageUrl'] ?? '',
      caption: map['caption'] ?? '',
      likes: List<String>.from(map['likes']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, date: $date, createdBy: $createdBy, postImageUrl: $postImageUrl, caption: $caption, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.date == date &&
        other.createdBy == createdBy &&
        other.postImageUrl == postImageUrl &&
        other.caption == caption &&
        listEquals(other.likes, likes);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        createdBy.hashCode ^
        postImageUrl.hashCode ^
        caption.hashCode ^
        likes.hashCode;
  }
}
