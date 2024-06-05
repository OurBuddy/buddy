import 'dart:convert';

import 'package:buddy/data/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Comment {
  String id;
  String post;
  DateTime createdAt;
  String createdBy;
  String content;
  Profile? profile;

  Comment({
    required this.id,
    required this.post,
    required this.createdAt,
    required this.createdBy,
    required this.content,
    this.profile,
  });

  Comment copyWith({
    String? id,
    String? post,
    DateTime? createdAt,
    String? createdBy,
    String? content,
    String? username,
    String? userImageUrl,
  }) {
    return Comment(
      id: id ?? this.id,
      post: post ?? this.post,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      content: content ?? this.content,
      profile: profile,
    );
  }

  Future<void> delete() async {
    await Supabase.instance.client.from('comments').delete().eq('id', id);
  }

  Future<void> report() async {
    await Supabase.instance.client.from('reports').insert({'commentId': id});
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'post': post,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'content': content,
    };
  }

  Map<String, dynamic> toMapWithProfile() {
    return {
      'id': id,
      'post': post,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'content': content,
      'profile': profile?.toMap(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] ?? '',
      post: map['post'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      createdBy: map['createdBy'] ?? '',
      content: map['content'] ?? '',
      profile: map['profile'] != null ? Profile.fromMap(map['profile']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Comment.fromJson(String source) =>
      Comment.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Comment(id: $id, post: $post, createdAt: $createdAt, createdBy: $createdBy, content: $content, profile: $profile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Comment &&
        other.id == id &&
        other.post == post &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.content == content &&
        other.profile == profile;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        post.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        content.hashCode ^
        profile.hashCode;
  }
}
