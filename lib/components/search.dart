import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:better_skeleton/skeleton_container.dart';
import 'package:buddy/states/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchDialog extends StatefulHookConsumerWidget {
  const SearchDialog({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchDialogState();
}

class _SearchDialogState extends ConsumerState<SearchDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // Debounce the search
  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchText = useTextEditingController();

    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 300,
        minWidth: 1000,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: searchText,
            onChanged: _onSearchChanged,
            decoration: const InputDecoration(
              hintText: "Search",
            ),
          ),
          FutureBuilder(
              future: ref
                  .read(userProvider.notifier)
                  .searchProfiles(searchText.text),
              builder: (context, future) {
                if (future.connectionState == ConnectionState.done &&
                    future.hasError) {
                  return const Center(child: Text('Error loading profiles'));
                }

                if (future.data?.isEmpty ?? false) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    child: Text(
                      'No profiles found!',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  );
                }
                if (future.connectionState == ConnectionState.done &&
                    (future.data == null)) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 9),
                    child: Text('Start Searching for Profiles!'),
                  );
                }

                if (future.connectionState == ConnectionState.done &&
                    future.data!.isNotEmpty) {
                  return Column(
                      children: List.generate(future.data!.length, (index) {
                    final profile = future.data![index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(99999),
                        onTap: () {
                          Navigator.of(context).pop();
                          Beamer.of(context)
                              .beamToNamed('/profile/${profile.id}');
                        },
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  const AssetImage("assets/dog-sitting.png"),
                              foregroundImage: CachedNetworkImageProvider(
                                Supabase.instance.client.storage
                                    .from('profile-pics')
                                    .getPublicUrl(profile.imageUrl ?? ''),
                              ),
                            ),
                            const SizedBox(width: 8),
                            RichText(
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                      text: profile.username,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                    text: '\n${profile.personName}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }));
                }

                return Column(
                  children: [
                    Column(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          child: AnimatedSkeleton(
                              listenable: animationController,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 1000,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          height: 20,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ],
                );
              })
        ],
      ),
    );
  }
}
