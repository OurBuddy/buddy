import 'package:buddy/components/textPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MiaDev extends StatefulWidget {
  const MiaDev({super.key});

  @override
  State<MiaDev> createState() => _MiaDevState();
}

class _MiaDevState extends State<MiaDev> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // PROFILE BAR
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Text('#', textAlign: TextAlign.center), // # of followers
                  Text('buddies', textAlign: TextAlign.center),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text('#', textAlign: TextAlign.center), // # of pics
                  Text('pics', textAlign: TextAlign.center),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Text('#', textAlign: TextAlign.center), // # of posts
                  Text('posts', textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        )
        //END OF PROFILE
      )
    );
  }
}
//trying to edit

