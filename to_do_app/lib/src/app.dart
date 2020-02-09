import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'providers/dashboard_provider.dart';
import 'providers/login_provider.dart';
import 'utils/theme.dart';

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DashboardProvider(),
        ),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: appTheme,
        home: Consumer<LoginProvider>(
          builder: (context, LoginProvider loginProvider, _) {
            return loginProvider.defaultHome;
          },
        ),
      ),
    );
  }
}
