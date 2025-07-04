import 'package:flutter/material.dart';

import 'package:window_manager/window_manager.dart';

class WindowManagerHelper {
  static WindowManagerHelper? _helper;

  WindowManagerHelper._();

  factory WindowManagerHelper() {
    _helper ??= WindowManagerHelper._();
    return _helper!;
  }

  Map<WindowManagerSize, Size> sizeMap = {
    WindowManagerSize.normal: const Size(1280, 720),
    WindowManagerSize.min: const Size(512, 384),
  };

  Future ensureInitialized() async {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = WindowOptions(
      size: sizeMap[WindowManagerSize.normal],
      center: true,
    );

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.setPreventClose(true);
      await windowManager.show();
      await windowManager.focus();
    });
  }

  Future handleMinModeWin() async {
    if (!await restoreWin()) {
      return;
    }

    var size = await windowManager.getSize();
    if (size == sizeMap[WindowManagerSize.normal]) {
      await windowManager.setSize(sizeMap[WindowManagerSize.min]!);
      await windowManager.setAlignment(Alignment.bottomLeft);
      await windowManager.setAlwaysOnTop(true);
    } else {
      await windowManager.setSize(sizeMap[WindowManagerSize.normal]!);
      await windowManager.setAlignment(Alignment.center);
      await windowManager.setAlwaysOnTop(false);
    }
  }

  Future restoreWin() async {
    var maximized = await windowManager.isMaximized();

    if (maximized) {
      await windowManager.unmaximize();
      return false;
    }

    var minimized = await windowManager.isMinimized();
    var visible = await isVisible();
    if (minimized || !visible) {
      await windowManager.show(inactive: true);
      return false;
    }

    return true;
  }

  Future isVisible() async {
    return windowManager.isVisible();
  }
}

enum WindowManagerSize { normal, min }
