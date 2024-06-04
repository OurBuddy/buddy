import 'dart:io';

import 'package:buddy/components/buttons.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import flutter_svg

class ImagePostDialog extends StatefulHookConsumerWidget {
  const ImagePostDialog({
    super.key,
  });

  @override
  ConsumerState<ImagePostDialog> createState() => _ImagePostDialogState();
}

class _ImagePostDialogState extends ConsumerState<ImagePostDialog> {
  CroppedFile? image;
  Future<String?>? post;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProvider).profile;
    final postController = useTextEditingController();

    if (image != null) {
      return SafeArea(
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

              return SafeArea(
                child: Padding(
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
                                : NetworkImage(Supabase.instance.client.storage
                                        .from('profile-pics')
                                        .getPublicUrl(profile.imageUrl!))
                                    as ImageProvider<Object>?,
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(image!.path),
                              width: 100,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons
                                    .error); // Provide a fallback icon in case of error
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: postController,
                              minLines: 4,
                              maxLines: 4,
                              enabled: future.connectionState !=
                                  ConnectionState.waiting,
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
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TonalButton(
                        isLoading:
                            future.connectionState == ConnectionState.waiting,
                        onPressed: () async {
                          post = ref
                              .read(postProvider.notifier)
                              .postImage(image!, postController.text);
                          setState(() {});
                        },
                        child: const Text('Post'),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            }),
      );
    }

    return SafeArea(
      bottom: true,
      top: false,
      child: SizedBox(
        height: 300,
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Open camera
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );

                  if (image == null) return;

                  //image crop
                  final cropped = await ImageCropper().cropImage(
                    sourcePath: image.path,
                    aspectRatio: const CropAspectRatio(
                      ratioX: 4,
                      ratioY: 5,
                    ),
                    maxHeight: 1024,
                  );

                  // Save image
                  setState(() {
                    this.image = cropped;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 231, 231, 230),
                        Color(0xFFE7E6E6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(
                      top: 8, right: 4, bottom: 8, left: 8),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/camera-front-color.png",
                        width: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Take a picture",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  // Open gallery
                  final image = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (image == null) return;
                  //image crop
                  final cropped = await ImageCropper().cropImage(
                    sourcePath: image.path,
                    aspectRatio: const CropAspectRatio(
                      ratioX: 4,
                      ratioY: 5,
                    ),
                    maxHeight: 1024,
                  );

                  // Save image
                  setState(() {
                    this.image = cropped;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 63, 63, 63),
                        Color.fromARGB(255, 0, 0, 0),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.only(
                      top: 8, right: 8, bottom: 8, left: 4),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/picture-front-clay.png",
                        width: 50,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Choose from Gallery",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
