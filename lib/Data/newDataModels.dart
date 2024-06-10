


class ringSingleRecord {
  final List<String> dataList;
  ringSingleRecord(this.dataList);
}

class ringListClass{
  final List<String> Headers;
  final List<String> ArHeaders;
  List<ringSingleRecord> ringList=[];
  //static List<String> fieldsHeader=['name','date','data'];
  //static List<String> fieldsArHeader=['اسم الحلقة','تاريخ إنشائها','بيانات'];

  ringListClass(this.Headers, this.ArHeaders);
  List<ringSingleRecord> get getringList=> ringList;

  List<String> get getfieldsArHeader=>ArHeaders;
  List<String> get getfieldsHeader=>Headers;

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
class data{
  static List<ringListClass> inst=[ringListClass(['name','date','data'],
      ['اسم الحلقة','تاريخ إنشائها','بيانات']),

    ringListClass(['aname','adate'],
        ['اسم','تاريخ'])

  ];
  static String dbaseName='ringdbase.db';
  static List<String> tableNames=['ringtable','studenttable'];
}

class studentSingleRecord{
  final List<String> dataList;
  studentSingleRecord(this.dataList);
}

class studentListClass{
  static List<studentSingleRecord> studentList=[];
  static List<String> fieldsHeader=['ring','name','age'];
}