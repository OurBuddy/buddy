import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/components/full_post.dart';
import 'package:buddy/data/post.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TextListView extends StatefulHookConsumerWidget {
  const TextListView({super.key, required this.id});

  final String? id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextListViewState();
}

class _TextListViewState extends ConsumerState<TextListView>
    with SingleTickerProviderStateMixin {
  Future<List<Post>>? pics;
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    pics ??= ref.read(postProvider.notifier).fetchAccTextPosts(id: widget.id);
    return FutureBuilder(
        future: pics,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
                child: Text('Error loading posts: ${snapshot.error}'));
          }
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) {
            return SliverList.builder(
              itemCount: 2,
              itemBuilder: (context, index) {
                return AnimatedSkeleton(
                  listenable: animationController,
                  child: Container(
                    height: 160,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            );
          }

          return SliverList.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];

              return FullPost(post: post, key: ValueKey(post.hashCode));
            },
          );
        });
  }
}
