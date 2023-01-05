import 'package:calendarapp/models/eventsDataSource.dart';
import 'package:calendarapp/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'eventForm.dart';

class CalendarDayView extends StatelessWidget {
  static const pageName = "CalendarDayView";
  const CalendarDayView({super.key});

  @override
  Widget build(BuildContext context) {
    final providerData =
        Provider.of<EventProvider>(context, listen: true).events;
    DateTime date = ModalRoute.of(context)!.settings.arguments as DateTime;
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('yyyy-MM-dd').format(date)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EventForm.pageName,
                    arguments: [CalendarDayView.pageName, date]);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: SfCalendar(
        view: CalendarView.day,
        initialDisplayDate: date,
        dataSource: EventsDataSource(providerData),
        appointmentTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
