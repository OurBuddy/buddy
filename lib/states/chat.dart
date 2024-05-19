import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatState {
  final StreamChatClient client;
  final String userId;
  final String userToken;
  final String userImageUrl;
  final String username;
  bool get isSignedIn => userId.isNotEmpty;

  ChatState({
    required this.client,
    required this.userId,
    required this.userToken,
    required this.userImageUrl,
    required this.username,
  });
}

class ChatProvider extends StateNotifier<ChatState> {
  ChatProvider(ref)
      : super(ChatState(
          client: StreamChatClient('b67pax5b2wdq'),
          userId: '',
          userToken: '',
          userImageUrl: '',
          username: '',
        )) {
    // Ftech the user's data from the database
    // and update the state
  }

  final Ref ref;

  void loginUser() {
    // Login the user

    // 1. Authenticate using Supabase to get token
  }
}
