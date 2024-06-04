import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/components/text_post.dart';
import 'package:buddy/data/post.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:buddy/components/image_post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedScreen extends StatefulHookConsumerWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  Future<List<Post>>? posts;

  @override
  void initState() {
    posts = ref.read(postProvider.notifier).fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(body: (context, scroll) {
        return FutureBuilder(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data == null) {
                return const Center(child: Text('Error loading posts'));
              }
              return RefreshIndicator(
                onRefresh: () async {
                  posts = ref.read(postProvider.notifier).fetchPosts();
                  setState(() {});
                  await posts;
                },
                child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  controller: scroll,
                  itemBuilder: (context, index) {
                    final post = snapshot.data![index];
                    if (post.postImageUrl != null) {
                      return ImagePost(post: post, key: Key(post.id));
                    } else {
                      return TextPost(post: post, key: Key(post.id));
                    }
                  },
                ),
              );
            });
      }),
      backgroundColor: const Color(0xFFE7E6E6),
    );
  }
}
