import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class SignUpStep5 extends StatefulHookConsumerWidget {
  const SignUpStep5({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateState();
}

class _CreateState extends ConsumerState<SignUpStep5> {
  Future<bool> isUserAvailable = Future.value(false);

  late final ImagePicker _picker;

  @override
  void initState() {
    _picker = ImagePicker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupProvider);
    final signupNotif = ref.watch(signupProvider.notifier);

    final person = useTextEditingController(text: signup.personName);
    final pet = useTextEditingController(text: signup.petName);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // First step, so select username
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Profile pic time!.',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      signup.hasPet ?? false
                          ? 'Add a photo of your pet! We\'re sure you\'re cute, but your buddy is cuter ;)'
                          : 'Add a photo of yourself or something you like!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 25),
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
                                    leading: const Icon(Icons.camera_alt),
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
                                              await ImageCropper().cropImage(
                                            sourcePath: pickedFile.path,
                                            aspectRatioPresets: [
                                              CropAspectRatioPreset.square,
                                            ],
                                            aspectRatio: const CropAspectRatio(
                                                ratioX: 1, ratioY: 1),
                                            cropStyle: CropStyle.circle,
                                            compressFormat:
                                                ImageCompressFormat.jpg,
                                            maxHeight: 512,
                                            maxWidth: 512,
                                          );

                                          if (cropped != null) {
                                            signupNotif.setProfilePic(
                                                XFile(cropped.path));
                                          } else {
                                            signupNotif
                                                .setProfilePic(pickedFile);
                                          }
                                        } catch (e) {
                                          signupNotif.setProfilePic(pickedFile);
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
                                            await ImageCropper().cropImage(
                                          sourcePath: pickedFile.path,
                                          aspectRatioPresets: [
                                            CropAspectRatioPreset.square,
                                          ],
                                          aspectRatio: const CropAspectRatio(
                                              ratioX: 1, ratioY: 1),
                                          cropStyle: CropStyle.circle,
                                          compressFormat:
                                              ImageCompressFormat.jpg,
                                          maxHeight: 512,
                                          maxWidth: 512,
                                        );

                                        if (cropped != null) {
                                          signupNotif.setProfilePic(
                                              XFile(cropped.path));
                                        } else {
                                          signupNotif.setProfilePic(pickedFile);
                                        }
                                      } catch (e) {
                                        signupNotif.setProfilePic(pickedFile);
                                      }

                                      // ignore: use_build_context_synchronously
                                      if (mounted) Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: signup.hasPet ?? false
                            ? const AssetImage('assets/dog-sitting.png')
                            : const AssetImage('assets/person.png'),
                        foregroundImage: signup.image != null
                            //XFile
                            ? FileImage(File(signup.image!.path))
                            : null,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Button(
                      onPressed: () {
                        signupNotif.setPersonName(person.text);
                        signupNotif.setPetName(pet.text);

                        Beamer.of(context)
                            .beamToNamed('/welcome/register/create');
                      },
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
