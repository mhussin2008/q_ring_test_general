


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

}
class data{
  static List<ringListClass> inst=[ringListClass(['name','date','data'],
      ['اسم الحلقة','تاريخ إنشائها','بيانات']),

    ringListClass(['aname','adate'],
        ['اسم','تاريخ'])

  ];

}

class studentSingleRecord{
  final List<String> dataList;
  studentSingleRecord(this.dataList);
}

class studentListClass{
  static List<studentSingleRecord> studentList=[];
  static List<String> fieldsHeader=['ring','name','age'];
}