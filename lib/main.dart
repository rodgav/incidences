import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:incidencias/app/core/utils/helpers/dependency_injection.dart';
import 'package:incidencias/app/core/utils/helpers/encrypt_helper.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DependencyInjection.init();
  await GetStorage.init();
  await initializeDateFormatting('es_ES');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final password =EncryptHelper().decrypt('3UJBeGmgxKCkHpQdQB4ZtgwkxIHJnU+e7br24M2XCUE=');
    debugPrint('password $password');
    return GetMaterialApp.router(
        initialBinding: BindingsBuilder(() {
          Get.put(AuthService());
        }),
        scrollBehavior: MyCustomScrollBehavior(),
        title: 'Incidencias',
        getPages: AppPages.routes);
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
