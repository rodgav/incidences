import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'incides_details_logic.dart';

class IncidesDetailsPage extends StatelessWidget {
  final logic = Get.find<IncidesDetailsLogic>();

  IncidesDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool web = size.width > 800;
    return  SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child:  Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [ web
                ? AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              title: const Text('Incidentes',
                  style: TextStyle(color: Colors.black)),
              centerTitle: true,
            )
                : const SizedBox(),
              const SizedBox(height: 20),
              Padding(
                padding:  const EdgeInsets.symmetric(horizontal: 20),
                child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Datos de la incidencia',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    IconButton(onPressed: logic.newIncid, icon:const Icon(Icons.edit))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GetBuilder<IncidesDetailsLogic>(
                  id: 'incidence',
                  builder: (_) {
                    final incidence = _.incidence;
                    return incidence != null
                        ? SizedBox(
                            width: size.width,
                            child: Wrap(
                              alignment: web
                                  ? WrapAlignment.spaceAround
                                  : WrapAlignment.start,
                              runAlignment: web
                                  ? WrapAlignment.spaceAround
                                  : WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Incidencia',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey)),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Título: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.title}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Tipo de incidencia: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.typeIncid}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Descripción: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.description}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'PDF: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            mouseCursor: SystemMouseCursors.click,
                                            text: 'aqui\n',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  _.launchPDF(incidence.pdfUrl)),
                                        const TextSpan(
                                            text: 'Fecha de creación: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.dateCreate}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Fecha de edición: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.dateModifi}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ])),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Creador',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey)),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Apellidos: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.lastName}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Nombre: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.name}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Teléfono: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${incidence.phone}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const Center(
                            child: Text('No hay datos'),
                          );
                  },
                ),
              ),
              const Divider(),
              const SizedBox(height: 20),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20),
                child:  Text(
                  'Datos de la solución',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GetBuilder<IncidesDetailsLogic>(
                  id: 'solution',
                  builder: (_) {
                    final solution = _.solution;
                    return solution != null
                        ? SizedBox(
                            width: size.width,
                            child: Wrap(
                              alignment: web
                                  ? WrapAlignment.spaceAround
                                  : WrapAlignment.start,
                              runAlignment: web
                                  ? WrapAlignment.spaceAround
                                  : WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Solución',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey)),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Título: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.title}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Descripción: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.description}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'PDF: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            mouseCursor: SystemMouseCursors.click,
                                            text: 'aqui\n',
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () =>
                                                  _.launchPDF(solution.pdfUrl)),
                                        const TextSpan(
                                            text: 'Fecha de creación: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.dateCreate}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Fecha de edición: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.dateModifi}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ])),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Creador',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey)),
                                      child: RichText(
                                          text: TextSpan(children: [
                                        const TextSpan(
                                            text: 'Apellidos: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.lastName}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Nombre: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.name}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                        const TextSpan(
                                            text: 'Teléfono: ',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text: '${solution.phone}\n',
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ])),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: ElevatedButton(
                                onPressed: logic.newSolution,
                                child: const Text('Crear solución')),
                          );
                  },
                ),
              ),
            ],
          )
      );
  }
}
