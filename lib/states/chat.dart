import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'providers.dart';

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
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  ChatProvider(this.ref)
      : super(ChatState(
          client: StreamChatClient('b67pax5b2wdq'),
          userId: '',
          userToken: '',
          userImageUrl: '',
          username: '',
        )) {
    // Ftech the user's data from the database
    // and update the state
    loginUser();
  }

  final Ref ref;

  void loginUser() async {
    // Login the user

    // 1. Authenticate using Supabase to get token
    final res = await _client.functions.invoke("getchat");

    // 2. Connect to Stream Chat
    final client = state.client;
    await client.connectUser(
      User(id: ref.read(userProvider).profile!.id, extraData: {
        'name': ref.read(userProvider).profile!.username,
        'image': _client.storage.from('profile-pics').getPublicUrl(
              ref.read(userProvider).profile!.imageUrl!,
            ),
      }),
      res.data['token'],
    );

    // 3. Update the state
    state = ChatState(
      client: client,
      userId: res.data['chat']['id'],
      userToken: res.data['token'],
      userImageUrl: res.data['chat']['image_url'],
      username: res.data['chat']['name'],
    );
  }
}
