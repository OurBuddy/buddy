import 'package:buddy/data/comments.dart';
import 'package:buddy/data/post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> reportPost(Post post) async {
  // Send a report to the backend
  await Supabase.instance.client
      .from('reports')
      .upsert({'postId': post.id, 'createdBy': post.createdBy});
}

Future<void> reportComment(Comment comment) async {
  // Send a report to the backend
  await Supabase.instance.client
      .from('reports')
      .upsert({'commentId': comment.id, 'createdBy': comment.createdBy});
}
