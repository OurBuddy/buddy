import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/buttons.dart';
import 'package:buddy/components/loading.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpStep1 extends StatefulHookConsumerWidget {
  const SignUpStep1({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpStep1State();
}

class _SignUpStep1State extends ConsumerState<SignUpStep1> {
  Future<bool> isUserAvailable = Future.value(false);

  @override
  Widget build(BuildContext context) {
    final signup = ref.watch(signupProvider);
    final signupNotif = ref.watch(signupProvider.notifier);

    final usernameController = useTextEditingController(text: signup.username);

    final usernameDebounce = useDebounced(
        usernameController.text, const Duration(milliseconds: 500));

    useEffect(() {
      isUserAvailable = signupNotif.checkUsername(username: usernameDebounce);

      // Cancel the future when the widget is disposed
      return () {
        isUserAvailable = Future.value(false);
      };
    }, [usernameDebounce]);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Back button
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.chevron_left_rounded, size: 32),
                  onPressed: () {
                    Beamer.of(context).beamBack();
                  },
                ),
              ),
              // First step, so select username
              Expanded(
                child: FutureBuilder<bool>(
                  builder: (context, future) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Create an account',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Use your pet\'s name!',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Username',
                          ),
                          controller: usernameController,
                          onChanged: (_) {
                            setState(() {
                              isUserAvailable = signupNotif.checkUsername(
                                  username: usernameController.text);
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        if (usernameController.text.isNotEmpty)
                          Row(
                            children: [
                              future.data ?? false
                                  ? future.connectionState ==
                                          ConnectionState.waiting
                                      ? Container(
                                          height: 20,
                                          width: 20,
                                          margin: const EdgeInsets.all(2),
                                          child: const LoadingSpinner(),
                                        )
                                      : const Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: Colors.green)
                                  : const Icon(Icons.remove_circle_outline,
                                      color: Colors.orange),
                              const SizedBox(width: 5),
                              Text(
                                future.data ?? false
                                    ? 'Username available'
                                    : 'Username not available',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        const SizedBox(height: 25),
                        Button(
                          onPressed: (future.connectionState ==
                                      ConnectionState.done &&
                                  future.data == true)
                              ? () {
                                  signupNotif
                                      .setUsername(usernameController.text);
                                  Beamer.of(context)
                                      .beamToNamed('/welcome/register/step2');
                                }
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    );
                  },
                  future: isUserAvailable,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
