import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Import flutter_svg

class ImagePost extends StatefulWidget {
  final String username;
  final String userImageUrl;
  final String postImageUrl;
  final String caption;
  final int likes;
  final int comments; // Number of comments
  final int sends; // Number of sends

  const ImagePost({
    super.key,
    required this.username,
    required this.userImageUrl,
    required this.postImageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.sends,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.userImageUrl),
            ),
            title: Text(widget.username),
          ),
          Image.asset(widget.postImageUrl),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/Posts/filledHeart.svg',
                    width: 22, height: 19),
                SizedBox(width: 8),
                Text('${widget.likes}'),
                SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledComment.svg',
                    width: 22, height: 19),
                SizedBox(width: 8),
                Text('${widget.comments}'),
                SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledSend.svg',
                    width: 22, height: 19),
                SizedBox(width: 8),
                Text('${widget.sends}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${widget.username} ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  TextSpan(
                    text: widget.caption,
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
