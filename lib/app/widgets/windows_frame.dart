import 'dart:io';

import 'package:flicker_free/app/common/global.dart';
import 'package:flicker_free/app/utils/theme_color_util.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowsFrame extends StatelessWidget {
  final Widget child;
  final double titleBarHeight;

  const WindowsFrame({
    super.key,
    required this.child,
    this.titleBarHeight = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) {
      return Scaffold(body: child);
    }

    return Scaffold(
      body: Column(
        children: [
          _buildTitleBar(context),
          Flexible(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      color: ThemeColorUtil.getPrimaryColorWithAlpha(context),
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        borderRadius: BorderRadius.circular(8), // 圆角半径
        child: child,
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context) {
    return Container(
      color: ThemeColorUtil.getPrimaryColorWithAlpha(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: DragToMoveArea(
              child: Container(
                width: double.infinity,
                height: titleBarHeight,
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Text(
                      '${Global.appName} v${Global.appVersion}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 138,
            height: titleBarHeight,
            child: WindowCaption(
              brightness: Theme.of(context).brightness,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
