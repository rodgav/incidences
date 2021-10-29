import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/modules/home/home_widgets/drawer_home.dart';
import 'package:incidencias/app/routes/app_pages.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool web = size.width > 800;
    return GetRouterOutlet.builder(builder: (context, delegate, current) {
      final title = current?.location;
      var titleF = '';
      if (title != null) {
        final title1 = title.split('/');
        if (title1.length >= 3) {
          titleF = title1[2];
        }
      }
      return SafeArea(
        child: Scaffold(
          appBar: web
              ? null
              : AppBar(
                  backgroundColor: Colors.white,
                  centerTitle: true,
                  title: Text(
                    'Incidencias ${titleF == 'solutions' ? '- Soluciones' : titleF == 'users' ? '- Usuarios' : ''}',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
          drawer: web ? const SizedBox() : const DrawerHome(),
          body: Row(
            children: [
              web ? const DrawerHome() : const SizedBox(),
              Expanded(
                child: GetRouterOutlet(
                  initialRoute: Routes.incides,
                  key: Get.nestedKey(Routes.home),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
