import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'incides_logic.dart';

class IncidesPage extends StatelessWidget {
  final logic = Get.find<IncidesLogic>();

  IncidesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool web = size.width > 1000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        web
            ? AppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                title: const Text('Incidentes',
                    style: TextStyle(color: Colors.black)),
                centerTitle: true,
              )
            : const SizedBox(),
        const SizedBox(height: 20),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Tipos de incidentes',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            )),
        const SizedBox(height: 5),
        GetBuilder<IncidesLogic>(
            id: 'typeIncis',
            builder: (_) {
              final typeInciModel = _.typeInciModel;
              final typeInci = _.typeInci;
              return SizedBox(
                height: 40,
                child: typeInciModel != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (__, index) {
                          final data = typeInciModel.typeInci[index];
                          return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    color: data == typeInci
                                        ? Colors.blue
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.blue)),
                                margin: const EdgeInsets.only(left: 20),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(data.name,
                                        style: TextStyle(
                                            color: data == typeInci
                                                ? Colors.white
                                                : Colors.blue))),
                              ),
                              onTap: () => _.selectTypeInci(data),
                            ),
                          );
                        },
                        itemCount: typeInciModel.typeInci.length)
                    : const Text('Tareas no encontradas'),
              );
            }),
        const Divider(),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 16)),
                onPressed:()=> logic.newIncid('new'),
                icon: const Icon(Icons.add),
                label: const Text('Nuevo')),
          ),
        ),
        const SizedBox(height: 5),
        Expanded(
            child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GetBuilder<IncidesLogic>(
                id: 'incidences',
                builder: (_) {
                  final incidencesModel = _.incidencesModel;
                  return web
                      ? incidencesModel != null
                          ? incidencesModel.incidences.isNotEmpty
                              ? SingleChildScrollView(
                                  controller: logic.scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(
                                          label: Text(
                                        'Número',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Usuario',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Título',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Estado',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'PDF',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'fecha de Creación',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'fecha de Edición',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Acciones',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )),
                                    ],
                                    rows: incidencesModel.incidences.map((e) {
                                      final index =
                                          incidencesModel.incidences.indexOf(e);
                                      return DataRow(cells: [
                                        DataCell(Text('$index')),
                                        DataCell(Text(e.name)),
                                        DataCell(Text(e.title)),
                                        DataCell(Text(
                                          e.soluInci.isNotEmpty
                                              ? 'Completo'
                                              : 'Incompleto',
                                          style: TextStyle(
                                              color: e.soluInci.isNotEmpty
                                                  ? Colors.green
                                                  : Colors.red),
                                        )),
                                        DataCell(TextButton(
                                            style: TextButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                textStyle: const TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () =>
                                                logic.toPDF(e.pdfUrl),
                                            child: const Text(
                                              'PDF',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                                        DataCell(Text(e.dateCreate.toString())),
                                        DataCell(Text(e.dateModifi.toString())),
                                        DataCell(PopupMenuButton<String>(
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                                child: Text('Editar'),
                                                value: 'edit'),
                                            const PopupMenuItem(
                                                child: Text('Detalles'),
                                                value: 'detail'),
                                          ],
                                          onSelected: (value) =>
                                              logic.selPopup(value, e),
                                        )),
                                      ]);
                                    }).toList(),
                                  ),
                                )
                              : const Center(
                                  child: Text('No hay datos'),
                                )
                          : const Center(
                              child: CircularProgressIndicator(),
                            )
                      : incidencesModel != null
                          ? incidencesModel.incidences.isNotEmpty
                              ? ListView.builder(
                                  controller: logic.scrollController,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (_, index) {
                                    final incidence =
                                        incidencesModel.incidences[index];
                                    final date = incidence.dateModifi;
                                    final dayWeek = DateFormat('EEEE', 'es_ES')
                                        .format(date);
                                    final day =
                                        DateFormat('d', 'es_ES').format(date);
                                    final month = DateFormat('MMMM', 'es_ES')
                                        .format(date);
                                    return ListTile(
                                        leading: CircleAvatar(
                                          child: Text(index.toString()),
                                        ),
                                        title: Text(incidence.title),
                                        subtitle:
                                            Text('$dayWeek $day de $month'),
                                        trailing: PopupMenuButton<String>(
                                          itemBuilder: (_) => [
                                            const PopupMenuItem(
                                                child: Text('PDF'),
                                                value: 'pdf'),
                                            const PopupMenuItem(
                                                child: Text('Editar'),
                                                value: 'edit'),
                                            const PopupMenuItem(
                                                child: Text('Detalles'),
                                                value: 'detail'),
                                          ],
                                          onSelected: (value) =>
                                              logic.selPopup(value, incidence),
                                        ));
                                  },
                                  itemCount: incidencesModel.incidences.length,
                                )
                              : const Center(
                                  child: Text('No hay datos'),
                                )
                          : const Center(
                              child: CircularProgressIndicator(),
                            );
                }),
          ),
        ))
      ],
    );
  }
}
