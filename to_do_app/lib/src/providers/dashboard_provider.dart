import 'package:flutter/cupertino.dart';
import '../utils/database_helper.dart';
import '../models/quick_note_model.dart';
import '../models/list_model.dart';

class DashboardProvider extends ChangeNotifier {
  bool _addIcon = true;
  double _opacity = 0.0;
  final dbHelper = DatabaseHelper.instance;
  List<QuickNote> _notesList = List<QuickNote>();
  List<String> _listNames = List<String>();
  List<ToDoList> _toDoList = List<ToDoList>();
  int _selectedDate = 0;
  String _stringDate =
      "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
  String _priority = 'none';
  bool _none = true;
  bool _medium = false;
  bool _high = false;
  int _tasks = 0;

  DashboardProvider() {
//    dbHelper.addList(
//      ToDoList(
//        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
//        name: "Workout",
//        content: "List value for workout list",
//        done: false,
//      ),
//    );
//    dbHelper.addList(
//      ToDoList(
//        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
//        name: "Workout",
//        content: "List value for workout list 2",
//        done: false,
//      ),
//    );
//    dbHelper.addList(
//      ToDoList(
//        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
//        name: "Workout",
//        content: "List value for workout list 3",
//        done: false,
//      ),
//    );
//    dbHelper.addList(
//      ToDoList(
//        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
//        name: "Groceries",
//        content: "List value for groceris list",
//        done: false,
//      ),
//    );
//    dbHelper.addList(
//      ToDoList(
//        date: "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
//        name: "Groceries",
//        content: "List value for groceries list 2",
//        done: false,
//      ),
//    );
    _queryLists();
    getLists(
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    getQuickNotes(
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
  }

  bool get addIcon => _addIcon;
  double get opacity => _opacity;
  List<QuickNote> get quickNotesList => _notesList;
  int get selectedDate => _selectedDate;
  List<ToDoList> get toDoList => _toDoList;
  List<String> get listNames => _listNames;
  bool get none => _none;
  bool get medium => _medium;
  bool get high => _high;
  String get priority => _priority;
  String get stringDate => _stringDate;
  int get tasks => _tasks;

  getQuickNotes(String date) async {
    _notesList = await dbHelper.fetchQuickNotes(date);
    if (date ==
            "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}" &&
        _notesList != null) {
      _tasks = _notesList.length;
    }
    notifyListeners();
  }

  getLists(String date) async {
    _listNames = await dbHelper.fetchListNames(date);
    _toDoList = await dbHelper.fetchList(date);
    notifyListeners();
  }

  addQuickNote(QuickNote note) async {
    await dbHelper.addQuickNote(note);
  }

  checkNote(QuickNote note) async {
    await dbHelper
        .updateQuickNote(note)
        .then((value) => getQuickNotes(note.date));
  }

  _queryLists() async {
    // get all rows
    List<Map> result = await dbHelper.queryAllRows("lists");

    // print the results
    result.forEach((row) => print(row));
  }

  setAddIcon(bool value) {
    _addIcon = value;
    notifyListeners();
  }

  setOpacity() {
    if (_opacity == 0.0) {
      Future.delayed(Duration(milliseconds: 1500), () {
        _opacity = 1.0;
        notifyListeners();
      });
    } else {
      _opacity = 0.0;
      notifyListeners();
    }
  }

  changeSelectedDate(int value) {
    _selectedDate = value;
    notifyListeners();
  }

  quickNotePriority(String priority) {
    if (priority == 'None') {
      _none = !_none;
      _priority = 'none';
      _medium = false;
      _high = false;
      notifyListeners();
    } else if (priority == 'Medium') {
      _medium = !_medium;
      _priority = 'medium';
      _none = false;
      _high = false;
      notifyListeners();
    } else {
      _high = !_high;
      _priority = 'high';
      _none = false;
      _medium = false;
      notifyListeners();
    }
  }

  setDate(String value) {
    _stringDate = value;
    notifyListeners();
  }
}
