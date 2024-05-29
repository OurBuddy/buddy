import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/components/profileHeader.dart';
import 'package:buddy/components/textPost.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:buddy/components/imagePost.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarBuddy(),
      body: BottomNav(body: (context, scroll) {
        return ListView(
          controller: scroll,
          children: <Widget>[
            Row(
              children: <Widget>[
                ProfileHeader(),
              ],
            ),
          ],
        );
      }),
      backgroundColor: Color(0xFFE7E6E6),
    );
  }
}
