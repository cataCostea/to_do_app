import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/src/models/quick_note_model.dart';
import 'package:to_do_app/src/providers/dashboard_provider.dart';

class QuickNotesArea extends StatelessWidget {
  Widget build(BuildContext context) {
    DashboardProvider dashProvider = Provider.of<DashboardProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
      child: ListView.builder(
        itemCount: dashProvider.quickNotesList != null
            ? dashProvider.quickNotesList.length
            : 1,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (dashProvider.quickNotesList != null &&
              dashProvider.quickNotesList.isNotEmpty) {
            Color priority;
            if (dashProvider.quickNotesList[index].priority == 'high') {
              priority = Color(0xFFFF4A4A);
            } else if (dashProvider.quickNotesList[index].priority ==
                'medium') {
              priority = Color(0xFFF3C018);
            } else {
              priority = Color(0xFF707070);
            }
            return GestureDetector(
              child: Container(
                margin: EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            dashProvider.quickNotesList[index].isChecked
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 15.0,
                            color: Color(0xFF878CAC),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            dashProvider.quickNotesList[index].noteContent,
                            style: TextStyle(
                              color: Color(0xFF878CAC),
                              decoration:
                                  dashProvider.quickNotesList[index].isChecked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(180)),
                          color: priority),
                    )
                  ],
                ),
              ),
              onTap: () {
                print(dashProvider.quickNotesList[index].id);
                dashProvider.checkNote(QuickNote(
                    date: dashProvider.quickNotesList[index].date,
                    noteContent: dashProvider.quickNotesList[index].noteContent,
                    isChecked: !dashProvider.quickNotesList[index].isChecked,
                    priority: dashProvider.quickNotesList[index].priority,
                    id: dashProvider.quickNotesList[index].id));
              },
            );
          }
          return Container(
            child: Text(
              "There are no notes for this day",
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
