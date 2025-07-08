import 'package:flicker_free/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('root')),
      body: GetRouterOutlet(initialRoute: AppPages.initial, anchorRoute: '/'),
    );
  }
}
