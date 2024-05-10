import 'package:buddy/components/textPost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FranDev extends StatefulWidget {
  const FranDev({super.key});

  @override
  State<FranDev> createState() => _FranDevState();
}

class _FranDevState extends State<FranDev> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: TextPost()),
      ),
    );
  }
}
