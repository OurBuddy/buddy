import 'package:buddy/components/buttons.dart';
import 'package:buddy/data/profile.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileHeader extends StatefulHookConsumerWidget {
  const ProfileHeader({super.key, this.profile});

  final Profile? profile;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    final profile = ref.read(userProvider.notifier).getProfileStats(
          id: widget.profile!.id,
        );

    final isOwnProfile =
        ref.read(userProvider).profile!.id == widget.profile!.id;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          children: [
            SizedBox(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundImage: widget.profile?.hasPet ?? false
                        ? const AssetImage('assets/dog-sitting.png')
                        : const AssetImage('assets/person.png'),
                    foregroundImage: widget.profile!.imageUrl == null
                        ? widget.profile?.hasPet ?? false
                            ? const AssetImage('assets/dog-sitting.png')
                            : const AssetImage('assets/person.png')
                        : NetworkImage(Supabase.instance.client.storage
                                .from('profile-pics')
                                .getPublicUrl(widget.profile!.imageUrl!))
                            as ImageProvider<Object>?,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('@${widget.profile!.username}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontSize: 24,
                                    color: Colors.black,
                                  )),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Row(
                              children: [
                                Text(
                                  widget.profile!.personName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey.shade700),
                                ),
                                Text(
                                  widget.profile!.hasPet
                                      ? ' and ${widget.profile!.petName}'
                                      : '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey.shade700),
                                ),
                                Expanded(
                                    child: Text(
                                  "Stanford, CA",
                                  textAlign: TextAlign.end,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: Colors.grey.shade700),
                                )),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          FutureBuilder(
                              future: profile,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return const Center(
                                      child: Text('An error occurred'));
                                }

                                return Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data['buddies'].toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            'buddies',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!['pics'].toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            'pics',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data!['posts'].toString(),
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          Text(
                                            'posts',
                                            textAlign: TextAlign.center,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Colors.grey.shade700),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                    widget.profile?.bio ??
                        'hewo! I still need to write a bio but just look at me,'
                            ' how could you be mad at meeeeee?',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
            if (!isOwnProfile)
              BuddyButton(
                ref: ref,
                widget: widget,
                profile: profile,
              )
          ],
        ),
      ),
    );
  }
}

class BuddyButton extends StatefulHookConsumerWidget {
  const BuddyButton({
    super.key,
    required this.ref,
    required this.widget,
    required this.profile,
  });

  final WidgetRef ref;
  final ProfileHeader widget;
  final Future<dynamic> profile;

  @override
  ConsumerState<BuddyButton> createState() => _BuddyButtonState();
}

class _BuddyButtonState extends ConsumerState<BuddyButton> {
  bool? isBuddyInt;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.profile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              isBuddyInt == null) {
            isBuddyInt = snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData &&
                snapshot.data['isBuddy'] == true;
          }
          return Button(
            isLoading: snapshot.connectionState == ConnectionState.waiting,
            onPressed: () async {
              if (isBuddyInt!) {
                await ref.read(userProvider.notifier).removeBuddy(
                      widget.widget.profile!.id,
                    );
              } else {
                await ref.read(userProvider.notifier).addBuddy(
                      widget.widget.profile!.id,
                    );
              }
              setState(() {
                isBuddyInt = !isBuddyInt!;
              });
            },
            child: Text(
              isBuddyInt ?? false ? 'Unbuddy' : 'Buddy',
            ),
          );
        });
  }
}
