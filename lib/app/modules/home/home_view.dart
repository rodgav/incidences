import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/routes/app_pages.dart';

import 'home_logic.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
                height: 70,
                width: size.width,
                child: Stack(
                  children: [
                    const Center(
                      child: Text(
                        'Incidencias',
                        style:
                            TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                        top: 0,
                        right: 10,
                        bottom: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(logic.lastName),
                            IconButton(
                                onPressed: logic.toDashBoard,
                                icon: const Icon(Icons.person))
                          ],
                        ))
                  ],
                )),
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
  }
}
