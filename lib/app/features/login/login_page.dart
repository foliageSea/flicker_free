import 'package:flutter/material.dart';
import 'package:flicker_free/app/layouts/base_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return BaseLayout(title: 'Login', child: Container());
  }
}
