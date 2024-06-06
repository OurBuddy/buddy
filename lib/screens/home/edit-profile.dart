import 'package:beamer/beamer.dart';
import 'package:buddy/components/appbar.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/components/loading.dart';
import 'package:buddy/components/navbar.dart';
import 'package:buddy/data/profile.dart';
import 'package:buddy/states/providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

class EditProfile extends StatefulHookConsumerWidget {
  const EditProfile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  late final ImagePicker _picker;
  XFile? profilePic;
  late Profile profile;
  Future<bool> isUserAvailable = Future.value(false);
  Future<void>? profileUpdate;

  @override
  void initState() {
    _picker = ImagePicker();
    profile = ref.read(userProvider).profile!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final usernameController = useTextEditingController(text: profile.username);
    final bio = useTextEditingController(text: profile.bio);
    final personName = useTextEditingController(text: profile.personName);
    final petName = useTextEditingController(text: profile.petName);

    return Scaffold(
      appBar: const AppBarBuddy(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final future = ref.read(userProvider.notifier).updateProfile(
                  profile.copyWith(
                    username: usernameController.text,
                    bio: bio.text,
                    personName: personName.text,
                    petName: petName.text,
                    imageUrl: profilePic != null
                        ? profilePic!.path
                        : profile.imageUrl,
                  ),
                );

            final profileImage = profilePic != null
                ? ref.read(userProvider.notifier).updateProfilePic(
                      File(profilePic!.path),
                    )
                : Future.value(null);

            setState(() {});
            await Future.wait([future, profileImage]);
          },
          label: const Text("Save"),
          icon: const Icon(Icons.save),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      body: BottomNav(
        body: (context, scroll) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              child: FutureBuilder(
                  future: profileUpdate,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: LoadingSpinner());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error),
                            const SizedBox(height: 10),
                            Text(snapshot.error.toString()),
                            const SizedBox(height: 10),
                            TonalButton(
                              onPressed: () {
                                setState(() {
                                  profileUpdate = null;
                                });
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/tick-dynamic-color.png',
                            height: 200,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Profile Updated!",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TonalButton(
                            onPressed: () {
                              Beamer.of(context).beamBack();
                            },
                            child: const Text("Back to Profile"),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                profileUpdate = null;
                              });
                            },
                            child: const Text("Edit Again"),
                          ),
                          const SizedBox(height: 100),
                        ],
                      );
                    }
                    return ListView(
                      controller: scroll,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading:
                                                const Icon(Icons.camera_alt),
                                            title: const Text('Camera'),
                                            onTap: () async {
                                              try {
                                                final pickedFile =
                                                    await _picker.pickImage(
                                                  source: ImageSource.camera,
                                                );

                                                if (pickedFile == null) return;

                                                try {
                                                  final cropped =
                                                      await ImageCropper()
                                                          .cropImage(
                                                    sourcePath: pickedFile.path,
                                                    aspectRatioPresets: [
                                                      CropAspectRatioPreset
                                                          .square,
                                                    ],
                                                    aspectRatio:
                                                        const CropAspectRatio(
                                                            ratioX: 1,
                                                            ratioY: 1),
                                                    cropStyle: CropStyle.circle,
                                                    compressFormat:
                                                        ImageCompressFormat.jpg,
                                                    maxHeight: 512,
                                                    maxWidth: 512,
                                                  );

                                                  if (cropped != null) {
                                                    setState(() {
                                                      profilePic =
                                                          XFile(cropped.path);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      profilePic = pickedFile;
                                                    });
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    profilePic = pickedFile;
                                                  });
                                                }

                                                if (mounted) {
                                                  // ignore: use_build_context_synchronously
                                                  Navigator.of(context).pop();
                                                }
                                              } catch (e) {
                                                return;
                                              }
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.photo),
                                            title: const Text('Gallery'),
                                            onTap: () async {
                                              final pickedFile =
                                                  await _picker.pickImage(
                                                source: ImageSource.gallery,
                                              );
                                              if (pickedFile == null) return;
                                              try {
                                                final cropped =
                                                    await ImageCropper()
                                                        .cropImage(
                                                  sourcePath: pickedFile.path,
                                                  aspectRatioPresets: [
                                                    CropAspectRatioPreset
                                                        .square,
                                                  ],
                                                  aspectRatio:
                                                      const CropAspectRatio(
                                                          ratioX: 1, ratioY: 1),
                                                  cropStyle: CropStyle.circle,
                                                  compressFormat:
                                                      ImageCompressFormat.jpg,
                                                  maxHeight: 512,
                                                  maxWidth: 512,
                                                );

                                                if (cropped != null) {
                                                  setState(() {
                                                    profilePic =
                                                        XFile(cropped.path);
                                                  });
                                                } else {
                                                  setState(() {
                                                    profilePic = pickedFile;
                                                  });
                                                }
                                              } catch (e) {
                                                setState(() {
                                                  profilePic = pickedFile;
                                                });
                                              }

                                              if (mounted) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: CircleAvatar(
                                radius: 60,
                                backgroundImage: profilePic != null
                                    ? FileImage(File(profilePic!.path))
                                    : profile.imageUrl != null
                                        ? CachedNetworkImageProvider(Supabase
                                            .instance.client.storage
                                            .from("profile-pics")
                                            .getPublicUrl(profile.imageUrl!))
                                        : profile.hasPet
                                            ? const AssetImage(
                                                'assets/dog-sitting.png')
                                            : const AssetImage(
                                                    'assets/person.png')
                                                as ImageProvider,
                                // Darken the image if profilePic is not null
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: profilePic == null
                                        ? Colors.black54
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                  child: profilePic == null
                                      ? const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: FutureBuilder<bool>(
                                builder: (context, future) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Username',
                                        ),
                                        controller: usernameController,
                                        onChanged: (_) {
                                          setState(() {
                                            isUserAvailable = ref
                                                .read(signupProvider.notifier)
                                                .checkUsername(
                                                    username: usernameController
                                                        .text);
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      if (usernameController.text.isNotEmpty &&
                                          usernameController.text !=
                                              profile.username)
                                        Row(
                                          children: [
                                            future.data ?? false
                                                ? future.connectionState ==
                                                        ConnectionState.waiting
                                                    ? Container(
                                                        height: 20,
                                                        width: 20,
                                                        margin: const EdgeInsets
                                                            .all(2),
                                                        child:
                                                            const LoadingSpinner(),
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .check_circle_outline_rounded,
                                                        color: Colors.green)
                                                : const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.orange),
                                            const SizedBox(width: 5),
                                            Text(
                                              future.data ?? false
                                                  ? 'Username available'
                                                  : 'Username not available',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                    ],
                                  );
                                },
                                future: isUserAvailable,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Purrsonal Details",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Your Name',
                          ),
                          controller: personName,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Pet Name',
                          ),
                          controller: petName,
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Bio',
                          ),
                          minLines: 3,
                          maxLines: 4,
                          controller: bio,
                          maxLength: 150,
                          maxLengthEnforcement: MaxLengthEnforcement.enforced,
                        ),
                        const SizedBox(height: 10),
                        TonalButton(
                            onPressed: () {
                              ref.read(authProvider.notifier).logOut();
                              ref.read(userProvider.notifier).logout();
                              Beamer.of(context).beamToNamed('/welcome');
                            },
                            child: Text("Logout")),
                        const SizedBox(
                          height: 100,
                        )
                      ],
                    );
                  }),
            ),
          );
        },
        back: true,
        backDestination: "/profile",
      ),
    );
  }
}
