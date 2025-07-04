import 'dart:developer';

import 'package:core/core.dart';
import 'package:flicker_free/app/events/events.dart';
import 'package:flicker_free/app/helpers/window_manager_helper.dart';
import 'package:hotkey_system/hotkey_system.dart';

class HotkeyHelper with AppLogMixin {
  static HotkeyHelper? _helper;

  HotkeyHelper._();

  factory HotkeyHelper() {
    _helper ??= HotkeyHelper._();
    return _helper!;
  }

  Future register() async {
    Map<HotKey, HotKeyHandler> hotkeys = {
      HotKey(
        KeyCode.digit1,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+1');
        fireGlobalEvent(EventType.toggle);
      },
      HotKey(
        KeyCode.digit2,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+2');
        WindowManagerHelper().handleMinModeWin();
      },
      HotKey(
        KeyCode.arrowLeft,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+左箭头');
        fireGlobalEvent(EventType.backward);
      },
      HotKey(
        KeyCode.arrowRight,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+右箭头');
        fireGlobalEvent(EventType.forward);
      },
      HotKey(
        KeyCode.arrowUp,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+上箭头');
        fireGlobalEvent(EventType.previous);
      },
      HotKey(
        KeyCode.arrowDown,
        modifiers: [KeyModifier.alt],
        scope: HotKeyScope.system,
      ): (hotKey) {
        log('Alt+下箭头');
        fireGlobalEvent(EventType.next);
      },
    };

    try {
      for (var e in hotkeys.keys) {
        await hotKeySystem.register(e, keyDownHandler: hotkeys[e]);
      }
    } catch (_) {}
  }

  Future unregisterAll() async {
    await hotKeySystem.unregisterAll();
    logger.log('注销所有快捷键');
  }
}
