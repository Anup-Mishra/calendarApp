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
      "from": eventObject.from.toIso8601String(),
      "to": eventObject.to.toIso8601String(),
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
        "from": e.from.toIso8601String(),
        "to": e.to.toIso8601String(),
      });
    }
  }

  Future<void> fetchEvents() async {
    final eventList = await DBHelper.getData("calendar_events");
    _events = eventList
        .map((e) {
          Event(
            title: e["title"] as String,
            description: e["description"] as String,
            from: DateTime.parse(e["from"] as String),
            to: DateTime.parse(e["to"] as String),
          );
        })
        .cast<Event>()
        .toList();
    notifyListeners();
  }
}
