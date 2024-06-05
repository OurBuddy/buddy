import 'dart:convert';

import 'package:buddy/data/comments.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Post {
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String? postImageUrl;
  final String? caption;
  final List<String> likedBy;
  final List<Comment>? comments;
  final String? username;
  final String? petowner;
  final String? userImageUrl;

  get likeCount => likedBy.length;
  get commentCount => comments?.length ?? 0;
  get getPostImageUrl => Supabase.instance.client.storage
      .from('posts')
      .getPublicUrl(postImageUrl!);
  get isLiked =>
      likedBy.contains(Supabase.instance.client.auth.currentUser!.id);

  Post({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    this.postImageUrl,
    this.caption,
    this.likedBy = const [],
    this.comments,
    this.username,
    this.petowner,
    this.userImageUrl,
  }) {
    assert(postImageUrl != null || caption != null,
        'Post must have either an image or a caption');
  }

  Future<void> like() async {
    if (likedBy.contains(Supabase.instance.client.auth.currentUser!.id)) {
      likedBy.remove(Supabase.instance.client.auth.currentUser!.id);
    } else {
      likedBy.add(Supabase.instance.client.auth.currentUser!.id);
    }

    await Supabase.instance.client
        .from('posts')
        .update(toPostMap())
        .eq('id', id);
  }

  Post copyWith({
    String? id,
    DateTime? createdAt,
    String? createdBy,
    ValueGetter<String?>? postImageUrl,
    ValueGetter<String?>? caption,
    List<String>? likedBy,
    ValueGetter<List<Comment>?>? comments,
    ValueGetter<String?>? username,
    ValueGetter<String?>? petowner,
    ValueGetter<String?>? userImageUrl,
  }) {
    return Post(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      postImageUrl: postImageUrl != null ? postImageUrl() : this.postImageUrl,
      caption: caption != null ? caption() : this.caption,
      likedBy: likedBy ?? this.likedBy,
      comments: comments != null ? comments() : this.comments,
      username: username != null ? username() : this.username,
      petowner: petowner != null ? petowner() : this.petowner,
      userImageUrl: userImageUrl != null ? userImageUrl() : this.userImageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'createdBy': createdBy,
      'postImageUrl': postImageUrl,
      'caption': caption,
      'likedBy': likedBy,
      'comments': comments?.map((x) => x.toMap()).toList(),
      'username': username,
      'petowner': petowner,
      'userImageUrl': userImageUrl,
    };
  }

  Map<String, dynamic> toPostMap() {
    return {
      'id': id,
      'createdAt': createdAt.toUtc().toIso8601String(),
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
      comments: map['comments'] != null
          ? List<Comment>.from(map['comments']?.map((x) => Comment.fromMap(x)))
          : null,
      username: map['username'],
      petowner: map['petowner'],
      userImageUrl: map['userImageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Post.fromJson(String source) => Post.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Post(id: $id, createdAt: $createdAt, createdBy: $createdBy, postImageUrl: $postImageUrl, caption: $caption, likedBy: $likedBy, comments: $comments, username: $username, petowner: $petowner, userImageUrl: $userImageUrl)';
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
        listEquals(other.likedBy, likedBy) &&
        listEquals(other.comments, comments) &&
        other.username == username &&
        other.petowner == petowner &&
        other.userImageUrl == userImageUrl;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        postImageUrl.hashCode ^
        caption.hashCode ^
        likedBy.hashCode ^
        comments.hashCode ^
        username.hashCode ^
        petowner.hashCode ^
        userImageUrl.hashCode;
  }
}
