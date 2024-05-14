import 'package:flutter/material.dart';
import 'package:buddy/components/textPost.dart';
import 'package:buddy/components/imagePost.dart';

class FeedScreen extends StatelessWidget {
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
      appBar: AppBar(
        title: Text('Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/create-post');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return ImagePost(
            username: post['username'],
            userImageUrl: post['userImageUrl'],
            postImageUrl: post['postImageUrl'],
            caption: post['caption'],
            likes: post['likes'] ?? 0,
            comments: post['comments'] ?? 0,
            sends: post['sends'] ?? 0,
          );
        },
      ),
    );
  }
}
