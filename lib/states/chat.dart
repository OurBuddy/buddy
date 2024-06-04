import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'providers.dart';

class ChatState {
  final StreamChatClient client;
  final OwnUser? ownUser;
  bool get isSignedIn => ownUser != null;

  ChatState({
    required this.client,
    required this.ownUser,
  });
}

class ChatProvider extends StateNotifier<ChatState> {
  final sb.SupabaseClient _client = sb.Supabase.instance.client;

  ChatProvider(this.ref)
      : super(ChatState(
          client: StreamChatClient('jfxqvpyrhqx9'),
          ownUser: null,
        )) {
    // Ftech the user's data from the database
    // and update the state
    loginUser();
  }

  final Ref ref;

  Future<void> loginUser() async {
    // Login the user

    // 1. Authenticate using Supabase to get token
    final res = await _client.functions.invoke("getchat");

    print(res.data["token"]);

    // 2. Connect to Stream Chat
    final user = await state.client.connectUser(
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
      client: state.client,
      ownUser: user,
    );
  }

  Future<Channel> createChat(String userId, String username) async {
    if (!state.isSignedIn) {
      await loginUser();
    }
    final channel = state.client.channel('messaging', extraData: {
      'members': [state.ownUser!.id, userId],
      'image': state.ownUser!.extraData['image'],
      'name': 'Chat between ${state.ownUser!.extraData['name']} and $username',
    });
    await channel.create();

    return channel;
  }
}
