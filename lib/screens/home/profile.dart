import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/components/profile_header.dart';
import 'package:buddy/data/profile.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<Profile?>? profile;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      profile = ref.read(userProvider.notifier).fetchProfileNoUpdate(
            id: widget.id,
          );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(
        body: (context, scroll) {
          return FutureBuilder(
              future: profile,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView(
                  controller: scroll,
                  children: <Widget>[
                    ProfileHeader(profile: snapshot.data),
                  ],
                );
              });
        },
        back: widget.id != null,
      ),
      backgroundColor: const Color(0xFFE7E6E6),
    );
  }
}
