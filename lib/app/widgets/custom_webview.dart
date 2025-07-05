import 'dart:async';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:core/core.dart';
import 'package:flicker_free/app/common/global.dart';
import 'package:flicker_free/app/constants/constants.dart';
import 'package:flicker_free/app/events/events.dart';
import 'package:flicker_free/app/helpers/hotkey_helper.dart';
import 'package:flicker_free/app/helpers/window_manager_helper.dart';
import 'package:flicker_free/app/widgets/star_dialog.dart';
import 'package:flicker_free/db/entity/star.dart';
import 'package:flicker_free/db/services/star_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:window_manager/window_manager.dart';

class CustomWebview extends StatefulWidget {
  const CustomWebview({super.key});

  @override
  State<CustomWebview> createState() => _CustomWebviewState();
}

class _CustomWebviewState extends State<CustomWebview>
    with AppLogMixin, AppMessageMixin {
  final _controller = WebviewController();
  final _textController = TextEditingController();
  final List<StreamSubscription> _subscriptions = [];
  var starService = Global.getIt<StarService>();

  Rx<Star> star = Star().obs;

  final Map<EventType, String> _scripts = {
    EventType.toggle: kToggleVideoScript,
    EventType.fullScreen: kFullScreenVideoScript,
    EventType.previous: kPreviousVideoScript,
    EventType.next: kNextVideoScript,
    EventType.backward: kBackwardVideoScript,
    EventType.forward: kForwardVideoScript,
  };

  @override
  void initState() {
    super.initState();
    initPlatformState();

    eventBus.on<GlobalEvent>().listen((e) async {
      if (!_scripts.containsKey(e.type)) {
        return;
      }
      if (!await WindowManagerHelper().isVisible()) {
        return;
      }
      await _controller.executeScript(_scripts[e.type]!);
    });
  }

  @override
  void dispose() {
    for (var s in _subscriptions) {
      s.cancel();
    }
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      await _controller.initialize();
      _subscriptions.add(
        _controller.url.listen((url) {
          _textController.text = url;
          if (star.value.url != null) {
            star.value.url = url;
            starService.update(star.value);
          }
        }),
      );

      _subscriptions.add(
        _controller.containsFullScreenElementChanged.listen((flag) {
          windowManager.setFullScreen(flag);
        }),
      );

      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(
        WebviewPopupWindowPolicy.sameWindow,
      );

      var list = await starService.list();

      late String url;
      if (list.isNotEmpty) {
        url = list.first.url!;
        star.value = list.first;
      } else {
        url = kDefaultUrl;
      }
      await _controller.loadUrl(url);

      if (!mounted) return;
      setState(() {});
    } on PlatformException catch (e, st) {
      logger.handle(e, st);
    }
  }

  Widget compositeView() {
    var width = MediaQuery.of(context).size.width;
    if (!_controller.value.isInitialized) {
      return const CupertinoActivityIndicator();
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            if (width > 640)
              Card(
                elevation: 0,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: 'URL',
                          contentPadding: EdgeInsets.all(10.0),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                        controller: _textController,
                        onSubmitted: (val) {
                          _controller.loadUrl(val);
                        },
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Obx(() => Text('${star.value.id}')),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      splashRadius: 20,
                      onPressed: () async {
                        await starService.add(Star()..url = kDefaultUrl);
                        var list = await starService.list();
                        star.value = list.last;
                        await _controller.loadUrl(kDefaultUrl);
                        await showToast('添加成功');
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.star_border),
                      splashRadius: 20,
                      onPressed: () async {
                        var star = await showDialog<Star>(
                          context: context,
                          builder: (BuildContext context) {
                            return const StarDialog();
                          },
                        );
                        if (star != null) {
                          this.star.value = star;
                          await _controller.loadUrl(star.url!);
                          await showToast('跳转成功');
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_left),
                      splashRadius: 20,
                      onPressed: () {
                        _controller.goBack();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_right),
                      splashRadius: 20,
                      onPressed: () {
                        _controller.goForward();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.fullscreen),
                      splashRadius: 20,
                      onPressed: () {
                        fireGlobalEvent(EventType.fullScreen);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      splashRadius: 20,
                      onPressed: () {
                        _controller.reload();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      tooltip: 'Open DevTools',
                      splashRadius: 20,
                      onPressed: () async {
                        var result = await showOkCancelAlertDialog(
                          context: context,
                          title: '询问',
                          message: '是否退出应用?',
                        );

                        if (result != OkCancelResult.ok) {
                          return;
                        }
                        await HotkeyHelper().unregisterAll();

                        exit(0);
                      },
                    ),
                  ].insertSizedBoxBetween(width: 4),
                ),
              ),
            Expanded(
              child: Card(
                color: Colors.transparent,
                elevation: 0,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: [
                    Webview(_controller),
                    StreamBuilder<LoadingState>(
                      stream: _controller.loadingState,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.data == LoadingState.loading) {
                          return const LinearProgressIndicator();
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   tooltip: _isWebviewSuspended ? 'Resume webview' : 'Suspend webview',
      //   onPressed: () async {
      //     if (_isWebviewSuspended) {
      //       await _controller.resume();
      //     } else {
      //       await _controller.suspend();
      //     }
      //     setState(() {
      //       _isWebviewSuspended = !_isWebviewSuspended;
      //     });
      //   },
      //   child: Icon(_isWebviewSuspended ? Icons.play_arrow : Icons.pause),
      // ),
      body: Center(child: compositeView()),
    );
  }
}
