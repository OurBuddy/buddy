import 'dart:convert';

import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String? postImageUrl;
  final String? caption;
  final List<String> likedBy;

  get likeCount => likedBy.length;

  Post({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    this.postImageUrl,
    this.caption,
    this.likedBy = const [],
  }) {
    assert(postImageUrl != null || caption != null,
        'Post must have either an image or a caption');
  }

  Post copyWith({
    String? id,
    DateTime? createdAt,
    String? createdBy,
    ValueGetter<String?>? postImageUrl,
    ValueGetter<String?>? caption,
    List<String>? likedBy,
  }) {
    return Post(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      postImageUrl: postImageUrl != null ? postImageUrl() : this.postImageUrl,
      caption: caption != null ? caption() : this.caption,
      likedBy: likedBy ?? this.likedBy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'postImageUrl': postImageUrl,
      'caption': caption,
      'likedBy': likedBy,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] ?? '',
      postImageUrl: map['postImageUrl'],
      caption: map['caption'],
      likedBy: List<String>.from(map['likedBy']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, createdAt: $createdAt, createdBy: $createdBy, postImageUrl: $postImageUrl, caption: $caption, likedBy: $likedBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.postImageUrl == postImageUrl &&
        other.caption == caption &&
        listEquals(other.likedBy, likedBy);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        postImageUrl.hashCode ^
        caption.hashCode ^
        likedBy.hashCode;
  }
}
