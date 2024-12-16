import 'package:flutter/material.dart';
import 'widgets.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Stack(
          children: [
            const PurpleBox(),
            _HeaderIcon(),
            child,
          ],
        ),
      ],
    ));
  }

  // ignore: non_constant_identifier_names
  SafeArea _HeaderIcon() {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: const Icon(
          Icons.person_pin,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
