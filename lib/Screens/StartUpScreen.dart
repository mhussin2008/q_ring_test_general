import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:q_ring_test/Screens/dataEntryScreen.dart';
import 'package:sqflite/sqflite.dart';
import '../Data/newDataModels.dart';
import 'DialogScreen.dart';

class startUpScreenUpdated extends StatelessWidget {
  const startUpScreenUpdated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('startup screen drawing');
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // const Center(child: Text('Start Up Screen')),

              OutlinedButton(
                onPressed: () async {
                  String result = await showDialog(
                      context: context,
                      builder: (BuildContext context) => const DialogScreen());

                  print(result);
                  if (result == 'OK') {
                    print('deleting');
                    await deleteDB();
                  }
                },
                child:
                    const Text('مسح قاعدة البيانات', style: TextStyle(fontSize: 24)),
              ),
              // SizedBox(height: 10),
              OutlinedButton(
                onPressed: ()  {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const dataEntryScreen( index: 1)));

                  }
                ,
                child:
                const Text('صفحة الطلبة', style: TextStyle(fontSize: 24)),
              ),

              OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                 const dataEntryScreen( index: 0)));
                  },
                  child: const Text('جدول الحلقات', style: TextStyle(fontSize: 24))),

              OutlinedButton(onPressed: (){

                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },

                  child: const Text('إنهاء البرنامج'))
              //SizedBox(height: 10),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteDB() async {
    var databasesPath = await getDatabasesPath();
    var dbFilePath = '$databasesPath/${data.dbaseName}';
    var dbExists = File(dbFilePath).existsSync();
    if (dbExists == true) {
      print('found and deleted database');
      await deleteDatabase(dbFilePath);
    }
  }
}
