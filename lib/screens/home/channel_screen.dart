import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelScreen extends StatefulHookConsumerWidget {
  const ChannelScreen({super.key, required this.id});

  final Channel id;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends ConsumerState<ChannelScreen> {
  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    if (chatState.client.state.currentUser == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Get channel by id
    return StreamChat(
      client: chatState.client,
      child: StreamChannel(
        channel: widget.id,
        child: const Scaffold(
          appBar: StreamChannelHeader(),
          body: Column(
            children: <Widget>[
              Expanded(
                child: StreamMessageListView(),
              ),
              StreamMessageInput(),
            ],
          ),
        ),
      ),
    );
  }
}
