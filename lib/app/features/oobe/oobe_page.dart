import 'package:flutter/material.dart';
import 'package:flicker_free/app/layouts/base_layout.dart';

class OobePage extends StatefulWidget {
  const OobePage({super.key});

  @override
  State<OobePage> createState() => _OobePageState();
}

class _OobePageState extends State<OobePage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(title: 'Oobe', child: Container());
  }
}
