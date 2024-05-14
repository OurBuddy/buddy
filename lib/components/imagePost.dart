import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class ImagePost extends StatefulWidget {
  final String username;
  final String userImageUrl;
  final String postImageUrl;
  final String caption;
  final int likes;

  const ImagePost({
    super.key,
    required this.username,
    required this.userImageUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likes,
  });

  @override
  State<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends State<ImagePost> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.userImageUrl),
            ),
            title: Text(widget.username),
          ),
          Image.asset(widget.postImageUrl),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(widget.caption),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text('${widget.likes} likes'),
          ),
        ],
      ),
    );
  }
}
