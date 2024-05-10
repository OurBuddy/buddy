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
        child: Center(child: TextPost()),
      ),
    );
  }
}
