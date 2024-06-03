import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:buddy/components/loading.dart';
import 'package:buddy/states/providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateScreen extends StatefulHookConsumerWidget {
  const CreateScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateScreenState();
}

class _CreateScreenState extends ConsumerState<CreateScreen> {
  late final Future<void> user;

  @override
  void initState() {
    super.initState();
    final signupNotif = ref.read(signupProvider.notifier);
    user = signupNotif.createUser();
  }

  @override
  Widget build(BuildContext context) {
    final signupNotif = ref.watch(signupProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Image.asset(
                            'assets/couch.dog.png',
                          ),
                        ),
                        Text(
                          'Oops! Something went wrong',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.error!.toString(),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 26),
                        ElevatedButton(
                          onPressed: () {
                            signupNotif.lastStep();
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 50),
                          child: Image.asset(
                            'assets/couch.dog.png',
                          ),
                        ),
                        Text(
                          'You\'re all set!',
                          style: Theme.of(context).textTheme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'You can now log in and start using Buddy!',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 26),
                        ElevatedButton(
                          onPressed: () {
                            signupNotif.reset();
                            Beamer.of(context).beamToNamed('/welcome/login');
                          },
                          child: const Text('Log in'),
                        ),
                      ],
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Image.asset(
                          'assets/couch.dog.png',
                        ),
                      ),
                      Text(
                        'Woohoo! I\'m creating your account now',
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'This will only take a few seconds...',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 26),
                      const LoadingSpinner(
                        padding: EdgeInsets.all(16),
                      )
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
