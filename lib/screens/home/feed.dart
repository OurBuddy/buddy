import 'package:buddy/components/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:buddy/components/textPost.dart' as text_widgets;
import 'package:buddy/components/imagePost.dart' as image_widgets;

class FeedScreen extends StatelessWidget {
  List<Map<String, dynamic>> _posts = [
    {
      'type': 'image',
      'username': 'Simba',
      'petowner': 'Francesca Bottazzini',
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
      'type': 'image',
      'username': 'Coquitz',
      'petowner': 'Violeta Zambrano',
      'userImageUrl': 'assets/images/coquita1.jpeg',
      'postImageUrl': 'assets/images/coquita2.jpeg',
      'caption': 'Hola chicos soy coquita pero me dicen coquitz',
      'likes': 85,
      'comments': 8,
      'sends': 3,
      'topcomments': [
        {
          'user': 'SillyCorgi',
          "text": 'Cute!!',
        },
        {
          'user': 'Freddy',
          "text": 'So good',
        }
      ]
    },
    {
      'type': 'text',
      'username': 'Coquitz',
      'petowner': 'Violeta Zambrano',
      'userImageUrl': 'assets/images/coquita1.jpeg',
      'caption':
          'Cant decide if the best part of the park is the grass buffet or the butt sniffing. Why not both?',
      'likes': 24,
      'comments': 8,
      'sends': 3,
      'topcomments': [
        {
          'user': 'SillyCorgi',
          "text": 'I always ask myself the same question',
        },
        {
          'user': 'CoolCat',
          "text": 'So good',
        }
      ]
    },
    // Add more posts as needed
  ];

  // custom 100px height appbar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      backgroundColor: Color(0xFFE7E6E6),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          if (post['type'] == 'image') {
            return image_widgets.ImagePost(
              username: post['username'],
              petowner: post['petowner'],
              userImageUrl: post['userImageUrl'],
              postImageUrl: post['postImageUrl'],
              caption: post['caption'],
              likes: post['likes'] ?? 0,
              comments: post['comments'] ?? 0,
              sends: post['sends'] ?? 0,
              topcomments: post['topcomments'],
            );
          } else {
            return text_widgets.TextPost(
              username: post['username'],
              petowner: post['petowner'],
              userImageUrl: post['userImageUrl'],
              caption: post['caption'],
              likes: post['likes'] ?? 0,
              comments: post['comments'] ?? 0,
              sends: post['sends'] ?? 0,
              topcomments: post['topcomments'],
            );
          }
        },
      ),
    );
  }
}
