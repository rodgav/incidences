import 'package:get/get.dart';
import 'package:incidencias/app/data/middlewares/auth_middleware.dart';
import 'package:incidencias/app/modules/home/home_binding.dart';
import 'package:incidencias/app/modules/home/home_view.dart';
import 'package:incidencias/app/modules/incides/incides_binding.dart';
import 'package:incidencias/app/modules/incides/incides_view.dart';
import 'package:incidencias/app/modules/incides_details/incides_details_binding.dart';
import 'package:incidencias/app/modules/incides_details/incides_details_view.dart';
import 'package:incidencias/app/modules/login/login_binding.dart';
import 'package:incidencias/app/modules/login/login_view.dart';
import 'package:incidencias/app/modules/root/root_binding.dart';
import 'package:incidencias/app/modules/root/root_view.dart';
import 'package:incidencias/app/modules/solutions/solutions_binding.dart';
import 'package:incidencias/app/modules/solutions/solutions_view.dart';
import 'package:incidencias/app/modules/solutions_details/solutions_details_binding.dart';
import 'package:incidencias/app/modules/solutions_details/solutions_details_view.dart';
import 'package:incidencias/app/modules/users/users_binding.dart';
import 'package:incidencias/app/modules/users/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;
  static final routes = [
    GetPage(
        name: '/',
        page: () => RootPage(),
        binding: RootBinding(),
        participatesInRootNavigator: true,
        preventDuplicates: true,
        children: [
          GetPage(
              preventDuplicates: true,
              middlewares: [EnsureNotAuthMiddleware()],
              name: _Paths.login,
              page: () => LoginPage(),
              binding: LoginBinding()),
          GetPage(
              preventDuplicates: true,
              middlewares: [EnsureAuthMiddleware()],
              name: _Paths.home,
              page: () => HomePage(),
              binding: HomeBinding(),
              children: [
                GetPage(
                    name: _Paths.incides,
                    page: () => IncidesPage(),
                    binding: IncidesBinding(),
                    children: [
                      GetPage(
                          name: _Paths.incidesDetails,
                          page: () => IncidesDetailsPage(),
                          binding: IncidesDetailsBinding())
                    ]),
                GetPage(
                    name: _Paths.solutions,
                    page: () => SolutionsPage(),
                    binding: SolutionsBinding(),
                    children: [
                      GetPage(
                          name: _Paths.solutionsDetails,
                          page: () => SolutionsDetailsPage(),
                          binding: SolutionsDetailsBinding())
                    ]),
                GetPage(
                    name: _Paths.users,
                    page: () => UsersPage(),
                    binding: UsersBinding())
              ]),
        ])
  ];
}
