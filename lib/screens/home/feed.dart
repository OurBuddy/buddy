import 'package:flutter/material.dart';
import 'package:buddy/components/textPost.dart';
import 'package:buddy/components/imagePost.dart';

class FeedScreen extends StatelessWidget {
  static final List<Map<String, dynamic>> _posts = [
    {
      'username': 'Simba',
      'userImageUrl': 'assets/images/simba1.jpg',
      'postImageUrl': 'assets/images/simba2.jpg',
      'caption': 'wena amigos',
      'likes': 150,
    },
    {
      'username': 'Coquitz',
      'userImageUrl': 'assets/images/coquita1.jpg',
      'postImageUrl': 'assets/images/coquita2.jpg',
      'caption': 'Hola chicos soy coquita pero me dicen coquitz',
      'likes': 85,
    },
    // Add more posts as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Feed')),
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
