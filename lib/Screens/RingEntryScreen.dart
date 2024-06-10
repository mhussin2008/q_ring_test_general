import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Data/ringDataSource.dart';
//import '../oldCode/QaryDataEntryScreen.dart';
import 'DialogScreen.dart';
import '../Data/newDataModels.dart';

class RingEntryScreen extends StatefulWidget {
  final   int  index;
  const RingEntryScreen({Key? key, required this.index}) : super(key: key);

  @override
  State<RingEntryScreen> createState() => _RingEntryScreenState();
}

class _RingEntryScreenState extends State<RingEntryScreen> {
  late List<TextEditingController> dataController ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('here');
   // print(widget.dataLink.runtimeType);
    dataController = List.generate(
        data.inst[widget.index].getfieldsHeader.length, (index) => TextEditingController());
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   CheckDbase();
    // });

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
    RingDataSource dataSource =
        RingDataSource(widget.index);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          titleSpacing: 10.0,
          title: const Text('صفحة إدخال بيانات الحلقات',
              style: TextStyle(fontSize: 20)),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < data.inst[widget.index].getfieldsHeader.length; i++)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
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
                        Text(data.inst[0].getfieldsArHeader[i]),
                      ],
                    ),
                    SizedBox(height: 10,)
                  ],
                ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///////////////////////////////////
                  OutlinedButton(
                      onPressed: () async {


                        if (data.inst[widget.index].getringList.any((test) => test
                            .dataList[0]
                            .contains(dataController[0].text))) {
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
                            data.inst[widget.index].ringList.add(ringSingleRecord(
                                dataController
                                    .map((toElement) => toElement.text)
                                    .toList()));
                            print(data.inst[widget.index].ringList);
                          });

                          String retVal = await CheckDbase();
                          if (retVal == 'Ok') {
                            print('ok');
                            await AddtoDb();
                          }
                          for (int i = 0; i < dataController.length; i++) {
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
                          data.inst[widget.index].getfieldsHeader.map((toElement) {
                            toElement = '';
                          });

                          FocusManager.instance.primaryFocus?.unfocus();
                          //print(TestList.toString());
                          //print(TestList.length.toDouble());
                          dataGridController.refreshRow(data.inst[widget.index].getfieldsHeader.length);
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

                  ///////////////////////////////////////////
                  OutlinedButton(
                      onPressed: () {
                       print(dataSource.cols.length);
                       print(dataSource.rows.length);
                       print(dataSource.rows[0].getCells().length);
                        // Navigator.pop(context);
                      },
                      child: const Text(
                        'عودة الى الشاشة الرئيسية',
                        textAlign: TextAlign.center,
                      )),
                ],
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
                              data.inst[widget.index].ringList.removeWhere((test)=>
                              test.dataList[0]==dataGridController.selectedRow
                                         ?.getCells()
                                         .first
                                         .value
                              );
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
                    child: OutlinedButton(
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
                          // postponed after editions
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             qaryDataEntry(testName: Selected)
                          //
                          //     ));
                        }
                        //Navigator.pop(context);
                      },
                      child: const Text(
                        'إدخال بيانات\n الطلبة',
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      ),
                    ),
                  ),
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
                              data.inst[widget.index].ringList.clear();
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
              const SizedBox(height: 10),
              Expanded(
                child: SfDataGrid(
                  allowEditing: true,
                  allowSorting: true,
                  selectionMode: SelectionMode.single,
                  columnWidthMode: ColumnWidthMode.fill,
                  isScrollbarAlwaysShown: true,
                  gridLinesVisibility: GridLinesVisibility.both,
                  headerGridLinesVisibility: GridLinesVisibility.both,
                  controller: dataGridController,
                  source: dataSource,
                  columns: dataSource.cols
                ),
              ),
            ],
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
    var tables = await db
        .rawQuery('SELECT * FROM sqlite_master WHERE name="${data.tableNames[widget.index]}";');

    if (tables.isEmpty) {
      // Create the table
      print('no such table');
      String fields='';
      for(int i=0;i<data.inst[widget.index].Headers.length;i++){
        fields=fields+ data.inst[widget.index].Headers[i]+' TEXT ,';
      }

fields=fields.substring(0, fields.length - 1);
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

    String headersline=data.inst[widget.index].headersOrdered;

    String line='';
    for(int i=0;i<dataController.length;i++){
      line=line+ "'" +dataController[i].text+"'"+' ,';
    }
    if(dataController.length>1){
      line=line.substring(0, line.length - 1);}

    String insertString =
        '''INSERT INTO ${data.tableNames[widget.index]} ( ${headersline} ) VALUES ( ${line} )''';

    print(insertString);
    await db.execute(insertString);
  }

  Future<void> GetFromDb() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    late Database db;
    db = await openDatabase(dbFilePath);
    List<Map<String, dynamic>>? gotlist =
        await db.database.rawQuery('SELECT * FROM ${data.tableNames[widget.index]}');
    print(gotlist);
    setState(() {
      data.inst[widget.index].ringList.clear();
      //TestList.clear();
    });
    if (gotlist.isNotEmpty) {
      setState(() {
        gotlist.forEach((e) {
          {

            print('e length=${e.length}');
            print('type is ${e.runtimeType}');
var hh= e.values.toList().cast<String>();
            // for(int _y=0;_y<hh.length;_y++){
            //   print(hh[_y]);
            // _datalist.add(hh[_y].toString());}
            //  // print('v=$v  act=$action');
            // };
print(hh);

           // print('_datalist=$_datalist');
             data.inst[widget.index].ringList
                 .add(ringSingleRecord(hh));
          }
          ;
        });
        print(data.inst[widget.index].ringList);
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
    await db.rawDelete('DELETE FROM ${data.tableNames[widget.index]} WHERE testname = ?', [tname]);
  }
}
