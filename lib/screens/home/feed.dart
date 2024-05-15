import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:flutter/material.dart';
import 'package:buddy/components/imagePost.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FeedScreen extends StatefulHookConsumerWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'Simba',
      'userImageUrl': 'assets/images/simba1.jpeg',
      'postImageUrl': 'assets/images/simba2.jpeg',
      'caption': 'wena amigos',
      'likes': 150,
      'comments': 10,
      'sends': 2,
      'topcomments': [
        {
          'user1': 'WifiThePoodle',
          "text": 'Love it!!',
        },
        {
          'user2': 'Anchulos',
          "text": 'Ah pero que sexy Simba',
        }
      ]
    },
    {
      'username': 'Coquitz',
      'userImageUrl': 'assets/images/coquita1.jpeg',
      'postImageUrl': 'assets/images/coquita2.jpeg',
      'caption': 'Hola chicos soy coquita pero me dicen coquitz',
      'likes': 85,
      'comments': 8,
      'sends': 3,
      'topcomments': [
        {
          'user1': 'SillyCorgi',
          "text": 'Cute!!',
        },
        {
          'user2': 'Freddy',
          "text": 'So good',
        }
      ]
    },
    // Add more posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(body: (context, scroll) {
        return ListView.builder(
          controller: scroll,
          itemCount: _posts.length,
          itemBuilder: (context, index) {
            return ImagePost(
              username: _posts[index]['username'],
              userImageUrl: _posts[index]['userImageUrl'],
              postImageUrl: _posts[index]['postImageUrl'],
              caption: _posts[index]['caption'],
              likes: _posts[index]['likes'],
              comments: _posts[index]['comments'],
              sends: _posts[index]['sends'],
            );
          },
        );
      }),
    );
  }
}
