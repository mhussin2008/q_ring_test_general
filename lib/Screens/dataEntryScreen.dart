import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Data/recordsDataSource.dart';
import 'DialogScreen.dart';
import '../Data/newDataModels.dart';

class dataEntryScreen extends StatefulWidget {
  final int index;
  final bool subTable;
  final String selected;
  const dataEntryScreen(
      {super.key,
      required this.index,
      this.subTable = false,
      this.selected = ''});

  @override
  State<dataEntryScreen> createState() => _dataEntryScreenState();
}

class _dataEntryScreenState extends State<dataEntryScreen> {
  late List<TextEditingController> dataController;
  bool folded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('here');
    // print(widget.dataLink.runtimeType);
    dataController = List.generate(data.inst[widget.index].Headers.length,
        (index) => TextEditingController());
    dataController[0].text = (widget.subTable == true) ? widget.selected : '';

    CheckDbase().then((value) {
      print(value);
      return {
        if (value == 'Ok')
          {
            GetFromDb().then((value) => {print('Loaded all data')})
          }
      };
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (int i = 0; i < dataController.length; i++) {
      dataController[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataGridController dataGridController = DataGridController();
    RecordsDataSource dataSource = RecordsDataSource(widget.index);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              setState(() {
                folded = !folded;
              });
            },
            icon: Icon(folded ? Icons.add : Icons.add_circle),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back))
          ],
          centerTitle: true,
          titleSpacing: 10.0,
          title: Text('صفحة إدخال بيانات  ${data.inst[widget.index].pageName}',
              style: const TextStyle(fontSize: 20)),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (folded) ...[
                  for (int i = 0; i < data.inst[widget.index].Headers.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                                scribbleEnabled: false,
                                readOnly:
                                    (data.link[widget.index] == true && i == 0)
                                        ? true
                                        : false,
                                style: const TextStyle(height: 0.5),
                                keyboardType: TextInputType.text,
                                textDirection: TextDirection.rtl,
                                controller: dataController[i],
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder())),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(data.inst[widget.index].ArHeaders[i]),
                        ],
                      ),
                    )
                  //else Container(),
                  ,
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        var si = (data.link[widget.index] == true) ? 1 : 0;
                        if (data.inst[widget.index].getRecordsList.any((test) =>
                            test.dataList[si]
                                .contains(dataController[si].text))) {
                          Fluttertoast.showToast(
                              msg: "بيانات الحلقة موجودة بالفعل ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          return;
                        }
            
                        //
                        bool empty = false;
                        dataController.forEach((element) {
                          if (element.text == '') {
                            empty = true;
                          }
                        });
            
                        if (empty == false) {
                          setState(() {
                            // TestList.add(TestData.fromFields(
                            //     nameController.text, dateController.text));
                            data.inst[widget.index].RecordsList.add(
                                dataSingleRecord(dataController
                                    .map((toElement) => toElement.text)
                                    .toList()));
                            print(data.inst[widget.index].RecordsList);
                          });
            
                          String retVal = await CheckDbase();
                          if (retVal == 'Ok') {
                            print('ok');
                            await AddtoDb();
                          }
                          // for (int i = 0; i < dataController.length; i++) {
                          //   dataController[i].text = '';
                          // }
                          for (int i = si;
                              i < data.inst[widget.index].Headers.length;
                              i++) {
                            dataController[i].text = '';
                          }
                          Fluttertoast.showToast(
                              msg: "تم إضافة بيانات الطالب بنجاح ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.blueAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
            
                          //nameController.text = '';
                          //dateController.text = '';
            
                          // data.inst[widget.index].Headers.map((toElement) {
                          //   toElement = '';
                          // });
            
                          FocusManager.instance.primaryFocus?.unfocus();
                          //print(TestList.toString());
                          //print(TestList.length.toDouble());
                          dataGridController
                              .refreshRow(data.inst[widget.index].Headers.length);
                          //dataGridController.scrollToRow(QaryList.length.toDouble());
            
                          // Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "بيانات الحلقة غير مكتملة",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: const Text(
                        'حفظ البيانات',
                        textAlign: TextAlign.center,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                          onPressed: () async {
                            if (dataGridController.selectedRow != null) {
                              String result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const DialogScreen());
            
                              print(result);
                              if (result == 'OK') {
                                print(dataGridController.selectedRow
                                    ?.getCells()
                                    .first
                                    .value);
                                String qname = dataGridController.selectedRow
                                    ?.getCells()
                                    .first
                                    .value;
            
                                setState(() {
                                  // TestList.removeWhere((element) =>
                                  //     element.testName ==
                                  //     dataGridController.selectedRow
                                  //         ?.getCells()
                                  //         .first
                                  //         .value);
                                  data.inst[widget.index].RecordsList.removeWhere(
                                      (test) =>
                                          test.dataList[0] ==
                                          dataGridController.selectedRow
                                              ?.getCells()
                                              .first
                                              .value);
                                });
                                await DelSrowFromDb(qname);
                              }
                              //Navigator.pop(context);
                            }
                          },
                          child: const Text(
                            'مسح بيانات \n الحلقة',
                            textAlign: TextAlign.center,
                          )),
                      SizedBox(
                          width: 100,
                          child: data.link[widget.index] == false
                              ? OutlinedButton(
                                  onPressed: () {
                                    String Selected = '';
                                    if (dataGridController.selectedRow != null) {
                                      Selected = dataGridController.selectedRow!
                                          .getCells()
                                          .first
                                          .value
                                          .toString();
            
                                      print(dataGridController.selectedRow
                                          ?.getCells()
                                          .first
                                          .value);
                                      //postponed after editions
                                      if (widget.subTable == false) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    dataEntryScreen(
                                                        index: 1,
                                                        subTable: true,
                                                        selected: Selected)));
                                      }
                                    }
                                    //Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'إدخال بيانات\n الطلبة',
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                )
                              : const SizedBox()),
                      SizedBox(
                        width: 100,
                        child: OutlinedButton(
                            onPressed: () async {
                              String result = await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const DialogScreen());
            
                              print(result);
                              if (result == 'OK') {
                                print('deleting');
                                setState(() {
                                  //TestList.clear();
                                  data.inst[widget.index].RecordsList.clear();
                                });
                                CheckDbase().then((value) async {
                                  if (value == 'Ok') {
                                    await ClearDb();
                                  }
                                  ;
                                });
                              }
                            },
                            child: const Text(
                              'مسح الجدول \n بالكامل',
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10)
                ] else
                  Container(),
                SizedBox(
                  height: 200,
                  child: SfDataGrid(
                    shrinkWrapRows: true,
                      allowEditing: true,
                      allowSorting: true,
                      selectionMode: SelectionMode.single,
                      columnWidthMode: ColumnWidthMode.fill,
                      isScrollbarAlwaysShown: true,
                      gridLinesVisibility: GridLinesVisibility.both,
                      headerGridLinesVisibility: GridLinesVisibility.both,
                      controller: dataGridController,
                      source: dataSource,
                      columns: dataSource.cols),
                ),
            
            OutlinedButton(onPressed: (){
            
            },
                child: Text('إضافة يوم'))
            
            
            
              ],
            ),
          ),
        ));
  }

  Future<String> CheckDbase() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == false) {
      print('no such database');
    } else {}
    late Database db;
    db = await openDatabase(data.dbaseName);
    if (db.isOpen == false) {
      print('cant open database');
      return 'No';
    }
    var tables = await db.rawQuery(
        'SELECT * FROM sqlite_master WHERE name="${data.tableNames[widget.index]}";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      String fields = '';
      for (int i = 0; i < data.inst[widget.index].Headers.length; i++) {
        fields = fields + data.inst[widget.index].Headers[i] + ' TEXT ,';
      }

      fields = fields.substring(0, fields.length - 1);
      print(fields);

      try {
        await db.execute('''
        CREATE TABLE ${data.tableNames[widget.index]} (
        ${fields}
        )''');
      } catch (err) {
        if (err.toString().contains('DatabaseException') == true) {
          print(err.toString());
          return 'No';
        }
      }
    }
    return 'Ok';
  }

  Future<void> AddtoDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    late Database db;
    db = await openDatabase(dbFilePath);
    String testdate = dataController[0].text; //dateController.text;
    //String line = ''' '${dataController[1].text}', '${testdate}' ''';
    String h;

    String headersline = data.inst[widget.index].headersOrdered;

    String line = '';
    for (int i = 0; i < dataController.length; i++) {
      line = line + "'" + dataController[i].text + "'" + ' ,';
    }
    if (dataController.length > 1) {
      line = line.substring(0, line.length - 1);
    }

    String insertString =
        '''INSERT INTO ${data.tableNames[widget.index]} ( ${headersline} ) VALUES ( ${line} )''';

    print(insertString);
    await db.execute(insertString);
  }

  Future<void> GetFromDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    List<Map<String, dynamic>>? gotlist = [];
    late Database db;
    db = await openDatabase(dbFilePath);
    if (widget.subTable == true) {
      String _queryText =
          '''SELECT * FROM ${data.tableNames[widget.index]} WHERE ${data.inst[widget.index].Headers[0]}= '${widget.selected}' ''';
      print(_queryText);
      gotlist = await db.database.rawQuery(_queryText);
    } else {
      gotlist = await db.database
          .rawQuery('SELECT * FROM ${data.tableNames[widget.index]}');
    }

    print(gotlist);
    setState(() {
      data.inst[widget.index].RecordsList.clear();
      //TestList.clear();
    });
    if (gotlist.isNotEmpty) {
      setState(() {
        gotlist?.forEach((e) {
          {
            print('e length=${e.length}');
            print('type is ${e.runtimeType}');
            var hh = e.values.toList().cast<String>();
            // for(int _y=0;_y<hh.length;_y++){
            //   print(hh[_y]);
            // _datalist.add(hh[_y].toString());}
            //  // print('v=$v  act=$action');
            // };
            print(hh);

            // print('_datalist=$_datalist');
            data.inst[widget.index].RecordsList.add(dataSingleRecord(hh));
          }
          ;
        });
        print(data.inst[widget.index].RecordsList);
      });
    }
  }

  Future<void> ClearDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.database.rawQuery('DELETE FROM ${data.tableNames[widget.index]}');
    setState(() {});
  }

  Future<void> DelSrowFromDb(String tname) async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    late Database db;
    db = await openDatabase(dbFilePath);
    await db.rawDelete(
        'DELETE FROM ${data.tableNames[widget.index]} WHERE testname = ?',
        [tname]);
  }
}
