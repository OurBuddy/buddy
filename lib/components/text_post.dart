import 'package:buddy/data/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart'; // Import flutter_svg

class TextPost extends StatefulHookConsumerWidget {
  final Post post;
  const TextPost({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<TextPost> createState() => _TextPostState();
}

class _TextPostState extends ConsumerState<TextPost>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            leading: CircleAvatar(
              backgroundImage: const AssetImage("assets/dog-sitting.png"),
              foregroundImage: NetworkImage(widget.post.userImageUrl ?? ""),
            ),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                      text: widget.post.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: '\n${widget.post.petowner}',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.more_horiz_rounded),
              onPressed: () {
                print('More options clicked.');
                // Implement more options logic
              },
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              widget.post.like();
              setState(() {});
              await HapticFeedback.mediumImpact();
              await Future.delayed(const Duration(milliseconds: 100));
              await HapticFeedback.lightImpact();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.post.caption!,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  child: GestureDetector(
                      onTap: () {
                        widget.post.like();
                        setState(() {});
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                              widget.post.isLiked
                                  ? 'assets/icons/Posts/colorHeart.svg'
                                  : 'assets/icons/Posts/filledHeart.svg',
                              width: 22,
                              height: 19),
                          const SizedBox(width: 8),
                          Text('${widget.post.likeCount}'),
                        ],
                      )),
                ),
                const SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledComment.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.post.commentCount}'),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    format(widget.post.createdAt),
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      color: Color(0xFF898989),
                      fontSize: 12,
                    ),
                  ),
                ),
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
                ...(widget.post.comments ?? []).map(
                  (comment) => Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "${comment.createdBy}: ",
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
