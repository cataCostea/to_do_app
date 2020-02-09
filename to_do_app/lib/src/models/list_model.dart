class ToDoList {
  String date;
  String name;
  String content;
  bool done;

  ToDoList({this.date, this.name, this.content, this.done});

  ToDoList.fromDb(Map<String, dynamic> map)
      : date = map['date'],
        name = map['list_name'],
        content = map['content'],
        done = map['done'] == 0 ? false : true;

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['date'] = date;
    map['list_name'] = name;
    map['content'] = content;
    map['done'] = done == true ? 1 : 0;
    return map;
  }
}
