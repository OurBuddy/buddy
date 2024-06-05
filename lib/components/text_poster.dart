import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TextPostDialog extends StatefulHookConsumerWidget {
  const TextPostDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TextPostDialogState();
}

class _TextPostDialogState extends ConsumerState<TextPostDialog> {
  Future<String?>? post;
  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProvider).profile;
    final postController = useTextEditingController();

    return SafeArea(
      top: false,
      bottom: true,
      child: FutureBuilder(
          future: post,
          builder: (context, future) {
            if (future.connectionState == ConnectionState.done) {
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) {
                  Navigator.pop(context);
                }
              });
              return SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/tick-dynamic-color.png',
                      width: 150,
                    ),
                    const Text(
                      'Posted!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 8,
                  left: 8,
                  right: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: profile?.hasPet ?? false
                            ? const AssetImage('assets/dog-sitting.png')
                            : const AssetImage('assets/person.png'),
                        foregroundImage: profile!.imageUrl == null
                            ? profile.hasPet
                                ? const AssetImage('assets/dog-sitting.png')
                                : const AssetImage('assets/person.png')
                            : CachedNetworkImage(
                                imageUrl: Supabase.instance.client.storage
                                    .from('profile-pics')
                                    .getPublicUrl(profile.imageUrl!),
                              ) as ImageProvider<Object>?,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${profile.username}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            profile.personName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: postController,
                    minLines: 6,
                    maxLines: 6,
                    enabled: future.connectionState != ConnectionState.waiting,
                    decoration: InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TonalButton(
                    isLoading:
                        future.connectionState == ConnectionState.waiting,
                    onPressed: () async {
                      post = ref
                          .read(postProvider.notifier)
                          .postText(postController.text);
                      setState(() {});
                    },
                    child: const Text('Post'),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }),
    );
  }
}
