class Note{
  int _id;
  String _title;
  String _descp;
  int _priority;
  String _date;
  Note.withId(this._id,this._title,this._date,this._priority,[this._descp]);
  Note(this._title,this._date,this._priority,[this._descp]);
  
  int get id => _id;
  String get title => _title;
  String get date=>_date;
  String get desc=>_descp;
  int get priority=>_priority;

  set title(String newTitle){
      this._title = newTitle;
  }
  set priority(int p){
    this._priority = p;
  }
  set date(String date){
    this._date = date;
  }
  
  set desc(String desc){
    this._descp = desc;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();

    if(_id!=null)
      map['id']=_id;
    
    map['title']=_title;
    map['description']=_descp;
    map['priority']=_priority;
    map['date']=_date;

    return map;

  }

  Note.fromMap(Map<String,dynamic> map){

    this._id = map['id'];
    this._title = map['title'];
    this._descp= map['description'];
    this._priority = map['priority'];
    this._date= map['date'];
  }
}