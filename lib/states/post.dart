import 'dart:convert';

import 'package:buddy/states/providers.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:buddy/data/post.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class PostState {
  final List<Post> posts;
  final bool loading;
  final String error;

  PostState({
    required this.posts,
    required this.loading,
    required this.error,
  });

  factory PostState.initial() {
    return PostState(
      posts: [],
      loading: false,
      error: '',
    );
  }

  PostState copyWith({
    List<Post>? posts,
    bool? loading,
    String? error,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'posts': posts.map((x) => x.toMap()).toList(),
      'loading': loading,
      'error': error,
    };
  }

  factory PostState.fromMap(Map<String, dynamic> map) {
    return PostState(
      posts: List<Post>.from(map['posts']?.map((x) => Post.fromMap(x))),
      loading: map['loading'] ?? false,
      error: map['error'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PostState.fromJson(String source) =>
      PostState.fromMap(json.decode(source));

  @override
  String toString() =>
      'PostState(posts: $posts, loading: $loading, error: $error)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PostState &&
        listEquals(other.posts, posts) &&
        other.loading == loading &&
        other.error == error;
  }

  @override
  int get hashCode => posts.hashCode ^ loading.hashCode ^ error.hashCode;
}

class PostProvider extends StateNotifier<PostState> {
  final Ref ref;
  final SupabaseClient client = Supabase.instance.client;

  PostProvider(this.ref) : super(PostState.initial()) {
    fetchPosts();
  }

  Future<String> postText(String text) async {
    // Trim, check if empty
    if (text.trim().isEmpty) {
      throw "Post cannot be empty";
    }

    final post = Post(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      createdBy: ref.read(userProvider).profile!.id,
      caption: text.trim(),
    );

    await client.from("posts").insert(post.toMap());

    return post.id;
  }

  Future<String> postImage(CroppedFile image, String caption) async {
    // Upload image
    final bytes = await image.readAsBytes();
    final filename =
        "${ref.read(userProvider).profile!.id}/${const Uuid().v4()}.jpg";

    final post = Post(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      createdBy: ref.read(userProvider).profile!.id,
      caption: caption,
      postImageUrl: filename,
    );

    await client.from("posts").insert(post.toMap());

    await client.storage.from("posts").uploadBinary(
          filename,
          bytes,
        );

    return post.id;
  }

  Future<void> fetchPosts() async {
    state = state.copyWith(loading: true);

    final posts = await client.from("posts").select("*").limit(50);

    state = state.copyWith(
      posts: posts.map((e) => Post.fromMap(e)).toList(),
      loading: false,
    );
  }
}
