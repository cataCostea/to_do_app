import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/src/providers/login_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../add_quick_note/add_quick_note.dart';
import 'quick_notes_area.dart';
import 'lists_area.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation animation;
  DashboardProvider dashProvider;
  LoginProvider login;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600));
    animation = Tween(begin: 0.0, end: 0.75).animate(_animationController);
  }

  @override
  void didChangeDependencies() {
    dashProvider = Provider.of<DashboardProvider>(context);
    login = Provider.of<LoginProvider>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            foregroundDecoration: BoxDecoration(
              color: dashProvider.addIcon
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                buildTitle(),
                buildDateTimeline(),
                Container(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Divider(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.3),
                  ),
                ),
                QuickNotesArea(),
                ListsArea(),
              ],
            ),
          ),
          buildMenuButton(1),
          buildMenuButton(2),
          buildMenuButton(3),
          buildMenuMainButton(),
        ],
      ),
    );
  }

  Widget buildTitle() {
    String name = login.userName;
    int tasksNumber = dashProvider.tasks;
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10.0, bottom: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: Text(
              "Hello $name",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            child: Text(
              tasksNumber > 1
                  ? "You have $tasksNumber tasks for today"
                  : "You have $tasksNumber task for today",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDateTimeline() {
    return Consumer<DashboardProvider>(
      builder: (context, dashProvider, _) {
        return Container(
          width: double.infinity,
          height: 70,
          child: ListView.builder(
            itemCount: 300,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DateTime _date = DateTime.now().add(Duration(days: index));
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5.0),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: dashProvider.selectedDate == index
                        ? Color(0xFFEFF1F9)
                        : Colors.transparent,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        _date.day.toString(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(dashProvider.selectedDate == index
                                  ? 1.0
                                  : 0.8),
                          fontWeight: FontWeight.w800,
                          fontSize: 17,
                        ),
                      ),
                      Text(
                        DateFormat('MMM').format(_date).toString(),
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(dashProvider.selectedDate == index
                                  ? 1.0
                                  : 0.8),
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  dashProvider.changeSelectedDate(index);
                  dashProvider
                      .setDate("${_date.day}/${_date.month}/${_date.year}");
                  dashProvider.getQuickNotes(
                      "${_date.day}/${_date.month}/${_date.year}");
                  dashProvider
                      .getLists("${_date.day}/${_date.month}/${_date.year}");
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget buildMenuMainButton() {
    return Positioned(
      top: 0.0,
      right: 10.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 1500),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: dashProvider.addIcon
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.5),
                      offset: Offset(0.0, 3.0),
                      blurRadius: 2.0,
                      spreadRadius: 1.0),
                ],
              ),
              child: AnimatedBuilder(
                animation: _animationController,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                builder: (context, child) {
                  return Transform.rotate(angle: animation.value, child: child);
                },
              ),
            ),
            onTap: () {
              dashProvider.setAddIcon(!dashProvider.addIcon);
              !dashProvider.addIcon
                  ? _animationController.forward()
                  : _animationController.reverse();
              dashProvider.setOpacity();
            },
          ),
        ],
      ),
    );
  }

  Widget buildMenuButton(int order) {
    double top;
    String buttonText;
    int animationDuration;
    IconData icon;
    switch (order) {
      case 1:
        {
          top = 60.0;
          animationDuration = 500;
          buttonText = "+ Add a quick note";
          icon = Icons.attach_file;
          break;
        }
      case 2:
        {
          top = 120.0;
          animationDuration = 1000;
          buttonText = "+ Add a reminder";
          icon = Icons.calendar_today;
          break;
        }
      case 3:
        {
          top = 180.0;
          animationDuration = 1500;
          buttonText = "+ Add a list";
          icon = Icons.note_add;
          break;
        }
      default:
        {
          break;
        }
    }
    return AnimatedPositioned(
      top: dashProvider.addIcon ? 0.0 : top,
      right: 10.0,
      duration: Duration(milliseconds: 1000),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              AnimatedOpacity(
                opacity: dashProvider.opacity,
                duration: Duration(milliseconds: 500),
                child: Text(
                  buttonText,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              GestureDetector(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: animationDuration),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      dashProvider.opacity == 1.0
                          ? BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.5),
                              offset: Offset(0.0, 3.0),
                              blurRadius: 2.0,
                              spreadRadius: 1.0)
                          : BoxShadow(color: Colors.transparent)
                    ],
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                onTap: () {
                  dashProvider.setAddIcon(!dashProvider.addIcon);
                  !dashProvider.addIcon
                      ? _animationController.forward()
                      : _animationController.reverse();
                  dashProvider.setOpacity();
                  if (icon == Icons.attach_file) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddQuickNote()),
                    );
                  } else if (icon == Icons.calendar_today) {
                    print("CALENDAR TODAY");
                  } else {
                    print("LAST");
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
