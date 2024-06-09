import 'package:flutter/material.dart';
//import 'package:q_ring_test/Data/testData.dart';
// import 'package:q_ring_test/Screens/RingEntryScreen.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'newDataModels.dart';

class RingDataSource extends DataGridSource {
  final int index;
  List<DataGridRow> _ringGridRow = [];
  List<GridColumn> _ringGridCol = [];

  RingDataSource(this.index ) {
    _ringGridRow = data.inst[index].ArHeaders
        .map<DataGridRow>((e) =>
        DataGridRow(
            cells: data.inst[index].getfieldsHeader
                .mapIndexed((index, toElement) =>
                DataGridCell<String>(
                    columnName: toElement, value: e))
                .toList()))
        .toList()
        .reversed
        .toList();

    _ringGridCol = data.inst[index].getfieldsArHeader.mapIndexed(
            (index, element) =>
            GridColumn(
                columnName: 'name',
                label: Container(
                    color: Colors.cyanAccent,
                    padding: const EdgeInsets.all(2.0),
                    alignment: Alignment.centerRight,
                    child:  Text(
                      '$element',
                    ))
            )).toList();
  }
    @override
    List<DataGridRow> get rows => _ringGridRow;

    @override
    DataGridRowAdapter? buildRow(DataGridRow row) {
      return DataGridRowAdapter(
        //color: Colors.lime,
          cells: row
              .getCells()
              .map<Widget>((dataGridCell) {
            return Container(
              //color: Colors.white,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  textAlign: TextAlign.right, dataGridCell.value.toString()),
            );
          })
              .toList()
              .reversed
              .toList());
    }
    List<GridColumn> get cols => _ringGridCol;
}