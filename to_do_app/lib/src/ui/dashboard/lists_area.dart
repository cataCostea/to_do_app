import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/dashboard_provider.dart';

class ListsArea extends StatelessWidget {
  Widget build(BuildContext context) {
    var dashProvider = Provider.of<DashboardProvider>(context);
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      margin: EdgeInsets.only(left: 15.0),
      child: ListView.builder(
        itemCount:
            dashProvider.listNames != null ? dashProvider.listNames.length : 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          if (dashProvider.listNames != null &&
              dashProvider.listNames.isNotEmpty) {
            double height = MediaQuery.of(context).size.height / 3;
            double width = MediaQuery.of(context).size.width / 2;
            return GestureDetector(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 1500),
                height: height,
                width: width,
                margin: EdgeInsets.only(right: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        dashProvider.listNames[index],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: Divider(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                      height: MediaQuery.of(context).size.height / 5,
                      child: ListView.builder(
                        itemCount: dashProvider.toDoList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, idx) {
                          if (dashProvider.toDoList[idx].name ==
                              dashProvider.listNames[index]) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(dashProvider.toDoList[idx].content),
                                Text(
                                    dashProvider.toDoList[idx].done.toString()),
                                Divider()
                              ],
                            );
                          }
                          return Container(
                            height: 0.0,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {},
            );
          }
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: Text(
              "There are no lists for this day",
              style: TextStyle(color: Colors.black),
            ),
          );
        },
      ),
    );
  }
}
