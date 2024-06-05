import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/image_post_switch.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/components/pic_grid.dart';
import 'package:buddy/components/profile_header.dart';
import 'package:buddy/components/text_list.dart';
import 'package:buddy/data/profile.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileScreen extends StatefulHookConsumerWidget {
  const ProfileScreen({super.key, this.id});

  final String? id;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<Profile?>? profile;
  bool isPic = true;

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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomScrollView(
                    controller: scroll,
                    slivers: <Widget>[
                      //ProfileHeader(profile: snapshot.data),
                      SliverToBoxAdapter(
                        child: ProfileHeader(profile: snapshot.data),
                      ),
                      SliverToBoxAdapter(
                        child: ImagePostSwitch(onImageClick: () {
                          setState(() {
                            isPic = true;
                          });
                        }, onPostClick: () {
                          setState(() {
                            isPic = false;
                          });
                        }),
                      ),
                      const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      if (isPic)
                        SliverSafeArea(
                          top: false,
                          minimum: const EdgeInsets.only(bottom: 80),
                          sliver: PicGridView(id: widget.id),
                        )
                      else
                        SliverSafeArea(
                          top: false,
                          minimum: const EdgeInsets.only(bottom: 80),
                          sliver: TextListView(id: widget.id),
                        ),
                    ],
                  ),
                );
              });
        },
        back: widget.id != null,
      ),
      backgroundColor: const Color(0xFFE7E6E6),
    );
  }
}
