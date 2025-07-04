import 'package:core/core.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flicker_free/app/helpers/window_manager_helper.dart';
import 'package:flutter/widgets.dart';
import 'package:flicker_free/app/controllers/controllers.dart';
import 'package:flicker_free/app/locales/locales.dart';
import 'package:flicker_free/db/database.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

final EventBus eventBus = EventBus();

class Global {
  static const String appName = "flicker_free";
  static String appVersion = "1.0.0";
  static final GetIt getIt = GetIt.instance;

  Global._();

  static void info(dynamic msg, [Object? exception, StackTrace? stackTrace]) {
    AppLogger().info(msg, exception, stackTrace);
  }

  static List<CommonInitialize Function()> getInitializes() {
    return [
      () => Storage(),
      () => Request(),
      () => PackageInfoUtil(),
      () => Locales(),
    ];
  }

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      var e = details.exception;
      var st = details.stack;
      AppLogger().handle(e, st);
    };

    var windowManagerHelper = WindowManagerHelper();
    await windowManagerHelper.ensureInitialized();
    await setSingleInstance([]);

    info('应用开始初始化');
    await initCommon();
    initAppVersion();
    await initDatabase();
    registerServices();

    info('应用初始化完成');
  }

  static Future initCommon() async {
    List<CommonInitialize Function()> initializes = getInitializes();
    for (var initialize in initializes) {
      var instance = initialize();
      await instance.init();
      info(instance.getOutput());
    }
  }

  static void registerServices() {
    var themeController = Get.put(ThemeController());
    themeController.init();
  }

  static Future initDatabase() async {
    getIt.registerSingleton(AppDatabase());
    await getIt<AppDatabase>().init(getIt);
  }

  static initAppVersion() {
    appVersion = PackageInfoUtil().getVersion();
  }

  /// windows设置单实例启动
  static Future setSingleInstance(List<String> args) async {
    await WindowsSingleInstance.ensureSingleInstance(
      args,
      Global.appName,
      onSecondWindow: (args) async {
        // 唤起并聚焦
        if (await windowManager.isMinimized()) await windowManager.restore();
        await windowManager.focus();
      },
    );
  }
}
