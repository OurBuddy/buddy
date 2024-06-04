import 'package:buddy/data/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart'; // Import flutter_svg

class TextPost extends StatefulWidget {
  final Post post;

  const TextPost({
    super.key,
    required this.post,
  });

  @override
  State<TextPost> createState() => _TextPostState();
}

class _TextPostState extends State<TextPost> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              backgroundImage: const AssetImage("assets/dog-sitting.png"),
              foregroundImage: NetworkImage(widget.post.userImageUrl ?? ""),
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                      text: widget.post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: '\n${widget.post.petowner}',
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
              widget.post.caption ?? "",
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
                Text('${widget.post.likeCount}'),
                const SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledComment.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.post.commentCount}'),
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
                ...widget.post.comments!.map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${comment.id}: ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.black)),
                          TextSpan(
                              text: comment.content,
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
