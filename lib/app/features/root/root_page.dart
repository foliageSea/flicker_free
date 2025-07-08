import 'package:flicker_free/app/routes/app_pages.dart';
import 'package:flicker_free/app/widgets/windows_frame.dart';
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
      body: WindowsFrame(
        child: GetRouterOutlet(
          initialRoute: AppPages.initial,
          anchorRoute: '/',
        ),
      ),
    );
  }
}
