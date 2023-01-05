import 'package:calendarapp/calendarDayView.dart';
import 'package:calendarapp/eventForm.dart';
import 'package:calendarapp/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calendarApp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(),
        title: 'Calendar App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CalendarApp(),
        routes: {
          CalendarApp.pageName: (context) => CalendarApp(),
          CalendarDayView.pageName: (context) => const CalendarDayView(),
          EventForm.pageName: (context) => const EventForm(),
        },
      ),
    );
  }
}
