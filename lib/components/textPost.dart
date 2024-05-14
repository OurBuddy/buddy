import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class TextPost extends StatefulWidget {
  final String username;
  final String userImageUrl;
  final String caption;
  final int likes;

  const TextPost({
    super.key,
    required this.username,
    required this.userImageUrl,
    required this.caption,
    required this.likes,
  });

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
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