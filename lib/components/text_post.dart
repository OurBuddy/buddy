import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Import flutter_svg

class TextPost extends StatefulWidget {
  final String username;
  final String petowner;
  final String userImageUrl;
  final String caption;
  final int likes;
  final int comments;
  final int sends;
  final List<Map<String, String>> topcomments; // List of top comments

  const TextPost({
    super.key,
    required this.username,
    required this.petowner,
    required this.userImageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
    required this.sends,
    required this.topcomments,
  });

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  String getUserName(Map<String, String> comment) {
    return comment.entries
        .firstWhere((entry) => entry.key.startsWith('user'))
        .value;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.userImageUrl),
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                      text: widget.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '\n${widget.petowner}',
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 14)),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              widget.caption,
              style: const TextStyle(
                  fontSize: 18), // Set the caption font size to 18
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/Posts/filledHeart.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.likes}'),
                const SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledComment.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.comments}'),
                const SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledSend.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.sends}'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    print('View all comments clicked.');
                    // Implement navigation or logic to show all comments
                  },
                  child: const Text(
                    'View all comments',
                    style: TextStyle(color: Color(0xFF898989), fontSize: 14),
                  ),
                ),
                const SizedBox(height: 4),
                ...widget.topcomments.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${getUserName(comment)}: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black)),
                          TextSpan(
                              text: comment['text'],
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
