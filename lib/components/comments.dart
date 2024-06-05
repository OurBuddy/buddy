import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/data/comments.dart';
import 'package:buddy/states/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentsSheet extends StatefulHookConsumerWidget {
  const CommentsSheet({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends ConsumerState<CommentsSheet>
    with SingleTickerProviderStateMixin {
  Future<List<Comment>>? comments;
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    comments ??= ref.read(postProvider.notifier).fetchComments(widget.id);
    final newCommentController = useTextEditingController();

    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.8,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 8,
            right: 8,
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: FutureBuilder(
                    future: comments,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading comments'));
                      }
                      if (snapshot.connectionState != ConnectionState.done ||
                          snapshot.data == null) {
                        return ListView.builder(
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 8),
                              child: AnimatedSkeleton(
                                  listenable: animationController,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 20,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 40,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        );
                      }
                      if (snapshot.data!.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/cat-sleeping.png',
                              width: 200,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ));
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: snapshot
                                            .data![index].profile?.hasPet ??
                                        false
                                    ? const AssetImage('assets/dog-sitting.png')
                                    : const AssetImage('assets/person.png'),
                                foregroundImage: snapshot
                                            .data![index].profile!.imageUrl ==
                                        null
                                    ? snapshot.data![index].profile!.hasPet
                                        ? const AssetImage(
                                            'assets/dog-sitting.png')
                                        : const AssetImage('assets/person.png')
                                    : CachedNetworkImageProvider(
                                        Supabase.instance.client.storage
                                            .from('profile-pics')
                                            .getPublicUrl(snapshot.data![index]
                                                .profile!.imageUrl!),
                                      ) as ImageProvider<Object>?,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '@${snapshot.data![index].profile!.username}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data![index].profile!.personName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(snapshot.data![index].content),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        itemCount: snapshot.data!.length,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newCommentController,
                          decoration: InputDecoration(
                            hintText: 'What\'s on your mind?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9999),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            fillColor: Colors.grey.shade200,
                            filled: true,
                          ),
                          onSubmitted: (value) async {
                            final fut = ref
                                .read(postProvider.notifier)
                                .postComment(
                                    widget.id, newCommentController.text);
                            newCommentController.clear();

                            await fut;
                            setState(() {
                              comments = null;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () async {
                          final fut = ref
                              .read(postProvider.notifier)
                              .postComment(
                                  widget.id, newCommentController.text);
                          newCommentController.clear();
                          await fut;
                          setState(() {
                            comments = null;
                          });
                        },
                        child: SvgPicture.asset(
                          'assets/icons/send.svg',
                          width: 50,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
