import 'package:get/get.dart';
import '../features/features.dart';
part 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static Transition transition = Transition.cupertino;

  static final _routes = [
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(name: AppRoutes.oobe, page: () => const OobePage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
  ];

  static List<String> whiteList = [];

  static List<GetPage<dynamic>> getRoutes() {
    final List<GetMiddleware> middlewares = [];

    List<GetPage<dynamic>> result = [];
    for (var r in _routes) {
      if (!whiteList.contains(r.name)) {
        final route = GetPage(
          name: r.name,
          page: r.page,
          middlewares: middlewares,
          transition: transition,
        );
        result.add(route);
      } else {
        final route = GetPage(
          name: r.name,
          page: r.page,
          transition: transition,
        );
        result.add(route);
      }
    }
    return result;
  }
}
