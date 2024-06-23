class dataSingleRecord {
  final List<String> dataList;
  dataSingleRecord(this.dataList);

  @override
  String toString() {
    // TODO: implement toString
    return 'data: ${dataList.toString()}';
  }
}
/////////////////////////
class dataListClass{
  final List<String> Headers;
  final List<String> ArHeaders;
  final String pageName;
  List<dataSingleRecord> RecordsList=[];
  //static List<String> fieldsHeader=['name','date','data'];
  //static List<String> fieldsArHeader=['اسم الحلقة','تاريخ إنشائها','بيانات'];

  dataListClass(this.Headers, this.ArHeaders, this.pageName);
  List<dataSingleRecord> get getRecordsList=> RecordsList;

  //List<String> get getfieldsArHeader=>ArHeaders;
  //List<String> get getfieldsHeader=>Headers;

  String get headersOrderedforCreation{
    String fields='';
    for(int i=0;i<Headers.length;i++){
    fields=fields+ Headers[i]+' TEXT ,';
    }
    if(Headers.length>1){
    fields=fields.substring(0, fields.length - 1);}

    return fields;
  }

  String get headersOrdered{
    String fields='';
    for(int i=0;i<Headers.length;i++){
      fields=fields+ Headers[i]+' ,';
    }
    if(Headers.length>1){
      fields=fields.substring(0, fields.length - 1);}
    return fields;
  }

}
//////////////////////////////////////////////////
class data{
  static List<dataListClass> inst=[dataListClass(['rname','date','data'],
      ['اسم الحلقة','تاريخ إنشائها','بيانات'],'الحلقات'),

    dataListClass(['rname','aname','adate','behave','parent'],
        ['اسم الحلقة','اسم الطالب','تاريخ الميلاد','السلوك','ولى الأمر'],'الطلبة'),


    dataListClass(['rname','sessiondate','aname','presence','saving','recovery'], [
      'اسم الحلقة','تاريخ الحلقة','اسم الطالب','الحضور','الحفظ','المراجعةشححم'
    ], 'الحصص')

  ];


  static String dbaseName='ringdbase.db';
  static List<String> tableNames=['ringtable','studenttable'];
  static List<bool> link=[false,true];
}
