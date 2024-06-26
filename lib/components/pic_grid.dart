import 'package:beamer/beamer.dart';
import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/data/post.dart';
import 'package:buddy/states/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PicGridView extends StatefulHookConsumerWidget {
  const PicGridView({super.key, required this.id});

  final String? id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PicGridViewState();
}

class _PicGridViewState extends ConsumerState<PicGridView>
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
    pics ??= ref.read(postProvider.notifier).fetchAccPics(id: widget.id);
    return FutureBuilder(
        future: pics,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
                child: Text('Error loading posts: ${snapshot.error}'));
          }
          if (snapshot.connectionState != ConnectionState.done ||
              snapshot.data == null) {
            return SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
                childAspectRatio: 4 / 5,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return AnimatedSkeleton(
                  listenable: animationController,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            );
          }
          // No posts
          if (snapshot.data!.isEmpty) {
            return SliverToBoxAdapter(
                child: Column(
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/floating-cat.png',
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'No posts yet',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.id == null
                      ? 'Start posting and spread the love!'
                      : 'When they post, they will appear here.',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ));
          }

          return SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 4 / 5,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];
              if (post.postImageUrl == null) {
                return const SizedBox();
              }
              return GestureDetector(
                onTap: () {
                  Beamer.of(context).beamToNamed('/post/${post.id}');
                },
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: AspectRatio(
                    aspectRatio: 4 / 5,
                    child: SizedBox(
                      height: 200,
                      child: Hero(
                        tag: post.id,
                        child: CachedNetworkImage(
                          imageUrl: post.getPostImageUrl ?? "",
                          errorWidget: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Failed to load image',
                              ),
                            );
                          },
                          placeholder: (context, url) {
                            return AnimatedSkeleton(
                              listenable: animationController,
                              child: Container(
                                width: double.infinity,
                                color: Colors.grey[200],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
