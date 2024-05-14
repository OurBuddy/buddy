import 'package:buddy/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:buddy/components/textPost.dart';
import 'package:buddy/components/imagePost.dart';
import 'package:flutter_svg/svg.dart';

class FeedScreen extends StatelessWidget {
  static final List<Map<String, dynamic>> _posts = [
    {
      'username': 'Simba',
      'userImageUrl': 'assets/images/simba1.jpeg',
      'postImageUrl': 'assets/images/simba2.jpeg',
      'caption': 'wena amigos',
      'likes': 150,
    },
    {
      'username': 'Coquitz',
      'userImageUrl': 'assets/images/coquita1.jpeg',
      'postImageUrl': 'assets/images/coquita2.jpeg',
      'caption': 'Hola chicos soy coquita pero me dicen coquitz',
      'likes': 85,
    },
    // Add more posts as needed
  ];

  // custom 100px height appbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return ImagePost(
            username: post['username'],
            userImageUrl: post['userImageUrl'],
            postImageUrl: post['postImageUrl'],
            caption: post['caption'],
            likes: post['likes'],
          );
        },
      ),
    );
  }
}
