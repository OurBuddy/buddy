import 'package:beamer/beamer.dart';
import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChatsScreen extends StatefulHookConsumerWidget {
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(body: (context, scroll) {
        if (chatState.client.state.currentUser == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return StreamChat(
          client: chatState.client,
          child: const ChannelListPage(),
        );
      }),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
  });

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          // Set the current channel
          Beamer.of(context).beamToNamed('/chat/${channel.cid}', data: channel);
        },
      ),
    );
  }
}
