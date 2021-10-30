import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:incidencias/app/data/services/auth_service.dart';
import 'package:incidencias/app/modules/home/home_logic.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
        id: 'drawer',
        builder: (logic) {
          final sel = logic.selectDrawer;
          return Drawer(
            child: Column(
              children: [
                DrawerHeader(
                    child: Column(
                  children: [
                    const SizedBox(
                      width: 70,
                      height: 70,
                      child: Placeholder(),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${logic.lastName} ${logic.name}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Text(logic.role,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListTile(
                          selected: sel == 'Incidentes',
                          selectedTileColor: sel == 'Incidentes'
                              ? Colors.blue
                              : Colors.transparent,
                          leading: Icon(Icons.error_outline,
                              color: sel == 'Incidentes'
                                  ? Colors.white
                                  : Colors.black),
                          title: Text('Incidentes',
                              style: TextStyle(
                                  color: sel == 'Incidentes'
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () => logic.selDrawer('Incidentes'),
                        ),
                        ListTile(
                          selected: sel == 'Soluciones',
                          selectedTileColor: sel == 'Soluciones'
                              ? Colors.blue
                              : Colors.transparent,
                          leading: Icon(Icons.error_outline,
                              color: sel == 'Soluciones'
                                  ? Colors.white
                                  : Colors.black),
                          title: Text('Soluciones',
                              style: TextStyle(
                                  color: sel == 'Soluciones'
                                      ? Colors.white
                                      : Colors.black)),
                          onTap: () => logic.selDrawer('Soluciones'),
                        ),
                        AuthService.to.role == 'admin'
                            ? ListTile(
                                selected: sel == 'Usuarios',
                                selectedTileColor: sel == 'Usuarios'
                                    ? Colors.blue
                                    : Colors.transparent,
                                leading: Icon(Icons.person_outline,
                                    color: sel == 'Usuarios'
                                        ? Colors.white
                                        : Colors.black),
                                title: Text('Usuarios',
                                    style: TextStyle(
                                        color: sel == 'Usuarios'
                                            ? Colors.white
                                            : Colors.black)),
                                onTap: () => logic.selDrawer('Usuarios'),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Cambiar contraseña'),
                  onTap: logic.updaPass,
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.red),
                  title: const Text('Salir'),
                  onTap: logic.closeSess,
                )
              ],
            ),
          );
        });
  }
}
