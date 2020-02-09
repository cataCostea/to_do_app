class QuickNote {
  int id;
  String date;
  bool isChecked;
  String noteContent;
  String priority;

  QuickNote(
      {this.date, this.isChecked, this.noteContent, this.priority, this.id});

  QuickNote.fromDb(Map<String, dynamic> map)
      : id = map['id'],
        date = map['date'],
        isChecked = map['done'] == 0 ? false : true,
        noteContent = map['content'],
        priority = map['priority'];

  Map<String, dynamic> toMapForDb() {
    var map = Map<String, dynamic>();
    map['date'] = date;
    map['done'] = isChecked == true ? 1 : 0;
    map['content'] = noteContent;
    map['priority'] = priority;
    return map;
  }
}
