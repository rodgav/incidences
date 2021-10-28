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
    final bool web = size.width > 800;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
          Center(
            child: SizedBox(
              width: web ? size.width * 0.5 : size.width,
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15),
                        textStyle: const TextStyle(fontSize: 18)),
                    onPressed: logic.newIncid,
                    icon: const Icon(Icons.add),
                    label: const Text('Nuevo')),
              ),
            ),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: web ? size.width * 0.5 : size.width,
              child: /* web
                  ? PaginatedDataTable(columns: const [
                      DataColumn(label: Text('Usuario')),
                      DataColumn(label: Text('Título')),
                      DataColumn(label: Text('pdfURL')),
                      DataColumn(label: Text('fecha de Creación')),
                      DataColumn(label: Text('fecha de Edición')),
                    ], source: MyDataTableSource())
                  :*/
                  GetBuilder<IncidesLogic>(
                      id: 'incidences',
                      builder: (_) {
                        final incidencesModel = _.incidencesModel;
                        return incidencesModel != null
                            ? incidencesModel.incidences.isNotEmpty
                                ? ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      final incidence =
                                          incidencesModel.incidences[index];
                                      final date = incidence.dateModifi;
                                      final dayWeek = DateFormat('EEEE', 'es_ES').format(date);
                                      final day = DateFormat('d', 'es_ES').format(date);
                                      final month = DateFormat('MMMM', 'es_ES').format(date);
                                      return ListTile(
                                        title: Text(incidence.title),
                                        subtitle: Text(
                                            '$dayWeek $day de $month'),
                                        trailing: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            child: const CircleAvatar(
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                'PDF',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            onTap: () => null,
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount:
                                        incidencesModel.incidences.length,
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
      ),
    );
  }
}

/*class MyDataTableSource extends DataTableSource {
  MyDataTableSource(this.data);

  final List<User> data;

  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text('${data[index].name}')),
        DataCell(Text('${data[index].sex}')),
        DataCell(Text('${data[index].age}')),
      ],
    );
  }

  @override
  int get selectedRowCount {
    return 0;
  }

  @override
  bool get isRowCountApproximate {
    return false;
  }

  @override
  int get rowCount {
    return data.length;
  }
}*/
