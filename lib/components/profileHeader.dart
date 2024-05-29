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
    print(widget.profile!.imageUrl!);

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
                    radius: 70,
                    backgroundImage: widget.profile!.imageUrl == null
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
                                  )),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                widget.profile!.personName,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.grey.shade700),
                              ),
                              Text(
                                widget.profile!.hasPet ?? false
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
                              )),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.location_on),
                              const SizedBox(width: 8),
                              Text(
                                widget.profile!.username,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
