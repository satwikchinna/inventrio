class Todo {
  int remainderid;
  String time;
  String remainder;
  

  Todo(this.remainderid, this.time, this.remainder);

  Todo.map(dynamic obj) {
    this.remainderid = obj["remainderid"];
    this.remainder = obj["remainder"];
    this.time = obj["time"];
  }

  

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["remainderid"] = remainderid;
    map["remainder"] = remainder;
    map['time'] = time;
   
    if (remainderid != null) {
      map['remainderid'] = remainderid;
    }

    return map;
  }

  Todo.fromMap(Map<String,dynamic> map)
  {
this.remainderid = map["remainderid"];
    this.remainder = map["remainder"];
    this.time = map["time"];
  }
}
