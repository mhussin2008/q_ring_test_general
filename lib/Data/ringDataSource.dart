import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'newDataModels.dart';

class RingDataSource extends DataGridSource {
  final int sourceIndex;
  List<DataGridRow> _ringGridRow = [];
  List<GridColumn> _ringGridCol = [];

  RingDataSource(this.sourceIndex) {

     _ringGridRow=data.inst[sourceIndex].getringList.mapIndexed<DataGridRow>((idx, element) =>
        DataGridRow(cells: element
        .dataList
        .mapIndexed((innerIndex, innerElement) => DataGridCell<String>(
            columnName: data.inst[sourceIndex].Headers[innerIndex],
            value: innerElement)).toList()
    )).toList().toList();

    ///عناوين الأعمدة//

    _ringGridCol = data.inst[sourceIndex].ArHeaders
        .mapIndexed((index, element) => GridColumn(
            columnName: element,
            label: Container(
                color: Colors.cyanAccent,
                padding: const EdgeInsets.all(2.0),
                alignment: Alignment.centerRight,
                child: Text(
                  '$element',
                ))))
        .toList();
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
