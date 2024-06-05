import 'package:beamer/beamer.dart';
import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/buttons.dart';
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
import 'package:url_launcher/url_launcher_string.dart';

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
                        child: ImagePostSwitch(
                          onImageClick: () {
                            setState(() {
                              isPic = true;
                            });
                          },
                          onPostClick: () {
                            setState(() {
                              isPic = false;
                            });
                          },
                          onGearClick: widget.id != null
                              ? null
                              : () {
                                  Beamer.of(context)
                                      .beamToNamed('/edit-profile');
                                },
                        ),
                      ),
                      /*if (snapshot.data?.id ==
                          ref.read(userProvider).profile?.id)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Button(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit-profile');
                              },
                              child: const Text('Edit Profile'),
                            ),
                          ),
                        ),*/
                      // Check if petName is null

                      if (snapshot.data?.petName == null)
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              Image.asset(
                                'assets/dog-with-leash.png',
                                width: 200,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'This is a hooman account!',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                widget.id == null
                                    ? 'You need a pet to post!'
                                    : 'They can’t post but they can still be your buddies!',
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (widget.id == null) ...[
                                const SizedBox(height: 20),
                                Button(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/add-pet');
                                  },
                                  child: const Text('I have a pet!'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    launchUrlString(
                                      "https://www.petfinder.com/",
                                      mode: LaunchMode.inAppBrowserView,
                                    );
                                  },
                                  child: const Text(
                                    'I want a pet, lets look at local shelters!',
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                            ],
                          ),
                        )
                      else if (isPic)
                        SliverSafeArea(
                          top: false,
                          minimum: const EdgeInsets.only(top: 20, bottom: 80),
                          sliver: PicGridView(id: widget.id),
                        )
                      else
                        SliverSafeArea(
                          top: false,
                          minimum: const EdgeInsets.only(top: 20, bottom: 80),
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
