import 'package:calendarapp/providers/eventProvider.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import "package:syncfusion_flutter_calendar/calendar.dart";
import 'calendarDayView.dart';
import 'eventForm.dart';
import 'models/eventsDataSource.dart';

class CalendarApp extends StatelessWidget {
  static const pageName = "CalendarApp";
  CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar App"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EventForm.pageName,
                    arguments: [CalendarApp.pageName]);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: FutureBuilder(
          future:
              Provider.of<EventProvider>(context, listen: false).fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                print(snapshot.error.toString());
                return const Center(
                  child: Text("Some Error Occurred"),
                );
              } else {
                return Consumer<EventProvider>(
                  builder: (_, eventData, child) {
                    return SfCalendar(
                      view: CalendarView.month,
                      dataSource: EventsDataSource(eventData.events),
                      initialSelectedDate: DateTime.now(),
                      todayHighlightColor: Colors.amber,
                      onTap: (calendarTapDetails) {
                        Navigator.of(context).pushNamed(
                            CalendarDayView.pageName,
                            arguments: calendarTapDetails.date);
                      },
                    );
                  },
                );
              }
            }
          }),
    );
  }
}
