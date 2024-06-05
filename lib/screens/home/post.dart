import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/components/full_post.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostScreen extends StatefulHookConsumerWidget {
  const PostScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(
        body: (context, scroll) {
          return SizedBox(
            height: double.infinity,
            child: FutureBuilder(
                future: ref.read(postProvider.notifier).fetchPost(widget.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text('Error loading postsxs'));
                  }
                  return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: SingleChildScrollView(
                        child: FullPost(
                          post: snapshot.data!,
                        ),
                      ));
                }),
          );
        },
        back: widget.id != null,
      ),
      backgroundColor: const Color(0xFFE7E6E6),
    );
  }
}
