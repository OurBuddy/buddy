import 'package:buddy/data/post.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PostActions extends StatefulHookConsumerWidget {
  const PostActions({super.key, required this.post});

  final Post post;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostActionsState();
}

enum PostAction { report, remove }

class _PostActionsState extends ConsumerState<PostActions> {
  Future<void>? future;
  PostAction? action;

  @override
  Widget build(BuildContext context) {
    final isOwnPost =
        ref.watch(userProvider).profile!.id == widget.post.createdBy;

    if (action != null) {
      return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return SafeArea(
              bottom: true,
              top: false,
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Hero(
                      tag:
                          'post-action-${action == PostAction.report ? 'report' : 'remove'}',
                      child: Image.asset(
                        action == PostAction.report
                            ? 'assets/icons/shield-front-color.png'
                            : 'assets/icons/fire-front-color.png',
                        width: 100,
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (action == PostAction.remove)
                      const Text(
                        'Removing...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      const Text(
                        'Reporting...',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return SafeArea(
              bottom: true,
              top: false,
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Text('Error: ${snapshot.error}'),
                ),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          }

          return SafeArea(
            bottom: true,
            top: false,
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Hero(
                    tag:
                        'post-action-${action == PostAction.report ? 'report' : 'remove'}',
                    child: Image.asset(
                      action == PostAction.report
                          ? 'assets/icons/shield-front-color.png'
                          : 'assets/icons/fire-front-color.png',
                      width: 100,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (action == PostAction.remove)
                    const Text(
                      'Removed!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else
                    const Text(
                      'Reported!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                ],
              ),
            ),
          );
        },
      );
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: SizedBox(
        height: 200,
        child: Row(
          children: [
            if (isOwnPost)
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      action = PostAction.remove;
                      future = widget.post.delete();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 231, 231, 230),
                          Color(0xFFE7E6E6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    margin: const EdgeInsets.only(
                        top: 8, right: 4, bottom: 8, left: 8),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'post-action-remove',
                          child: Image.asset(
                            "assets/icons/fire-front-color.png",
                            width: 50,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Remove Post",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  setState(() {
                    action = PostAction.report;
                    future = widget.post.report();
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 110, 110, 110),
                        Color.fromARGB(255, 35, 35, 35),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(
                      top: 8, right: 8, bottom: 8, left: 4),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'post-action-report',
                        child: Image.asset(
                          "assets/icons/shield-front-color.png",
                          width: 50,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Report Post",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
