import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/data/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; // Import flutter_svg

class ImagePost extends StatefulHookConsumerWidget {
  final Post post;
  const ImagePost({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ImagePost> createState() => _ImagePostState();
}

class _ImagePostState extends ConsumerState<ImagePost>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.post.isLiked);
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
              final like = widget.post.like();
              setState(() {});
              await HapticFeedback.mediumImpact();
              await Future.delayed(const Duration(milliseconds: 100));
              await HapticFeedback.lightImpact();
            },
            child: AspectRatio(
              aspectRatio: 4 / 5,
              child: SizedBox(
                width: double.infinity,
                child: Image.network(
                  widget.post.getPostImageUrl ?? "",
                  gaplessPlayback: true,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text(
                        'Failed to load image',
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      if (loadingProgress.cumulativeBytesLoaded ==
                          loadingProgress.expectedTotalBytes) {
                        return child;
                      }
                      return AnimatedSkeleton(
                        listenable: animationController,
                        child: Container(
                          width: double.infinity,
                          color: Colors.grey[200],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                const SizedBox(width: 16),
                SvgPicture.asset('assets/icons/Posts/filledComment.svg',
                    width: 22, height: 19),
                const SizedBox(width: 8),
                Text('${widget.post.commentCount}'),
                const SizedBox(width: 16),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '${widget.post.username} ',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  TextSpan(
                      text: widget.post.caption,
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
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
