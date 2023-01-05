import 'package:flutter/material.dart';
import '../models/event.dart';
import '../db_helper.dart';

class EventProvider extends ChangeNotifier {
  List<Event> _events = [];
  List<Event> get events => _events;

  void addEvent(Event eventObject) {
    _events.add(eventObject);
    notifyListeners();
    DBHelper.insert('calendar_events', {
      "id": DateTime.now().toString(),
      "title": eventObject.title,
      "description": eventObject.description,
      "startDate": eventObject.from.toIso8601String(),
      "endDate": eventObject.to.toIso8601String(),
    });
  }

  void addEventList(List<Event> eventObject) {
    _events.addAll(eventObject);
    notifyListeners();
    for (var e in eventObject) {
      DBHelper.insert('calendar_events', {
        "id": DateTime.now().toString(),
        "title": e.title,
        "description": e.description,
        "startDate": e.from.toIso8601String(),
        "endDate": e.to.toIso8601String(),
      });
    }
  }

  Future<void> fetchEvents() async {
    final eventList = await DBHelper.getData("calendar_events");
    _events = eventList.map((e) {
      return Event(
        title: e["title"] as String,
        description: e["description"] as String,
        from: DateTime.parse(e["startDate"] as String),
        to: DateTime.parse(e["endDate"] as String),
      );
    }).toList();
    notifyListeners();
  }
}
