import 'dart:math';

import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/data/post.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:buddy/components/full_post.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedScreen extends StatefulHookConsumerWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen>
    with SingleTickerProviderStateMixin {
  Future<List<Post>>? posts;
  late AnimationController _controller;

  @override
  void initState() {
    posts = ref.read(postProvider.notifier).fetchPosts();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(body: (context, scroll) {
        return FutureBuilder(
            future: posts,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done &&
                  snapshot.data == null) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: List.generate(
                      4,
                      (index) {
                        // Randomly generate height from [100, 200, 1000]
                        //get radnom number 1 through 3
                        final list = [200, 500];
                        Random random = Random();
                        int randomNumber = random.nextInt(list.length);

                        return AnimatedSkeleton(
                          listenable: _controller,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            //Randomly generate height from [100, 200, 1000]
                            height: list[randomNumber].toDouble(),
                          ),
                        );
                      },
                    ),
                  ),
                );
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
                    return FullPost(post: post, key: ValueKey(post.hashCode));
                  },
                ),
              );
            });
      }),
      backgroundColor: const Color(0xFFE7E6E6),
    );
  }
}
