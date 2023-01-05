import 'package:calendarapp/models/event.dart';
import 'package:calendarapp/providers/eventProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'calendarApp.dart';

class EventForm extends StatefulWidget {
  static const pageName = "event-form";
  const EventForm({super.key});

  @override
  State<EventForm> createState() => EventFormState();
}

class EventFormState extends State<EventForm> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController eventDescriptionController = TextEditingController();
  final focusEventDescription = FocusNode();
  Color pickerColor = const Color.fromARGB(255, 220, 210, 21);
  Color currentColor = const Color.fromARGB(255, 33, 208, 10);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      fromDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      toDateController.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
      startTimeController.text =
          TimeOfDay.fromDateTime(DateTime.now()).format(context);
      endTimeController.text =
          TimeOfDay.fromDateTime(DateTime.now()).format(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    eventDescriptionController.dispose();
    focusEventDescription.dispose();
  }

  Future<DateTime?> datePicker(BuildContext ctx) {
    return showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2040),
    );
  }

  Future<TimeOfDay?> timePicker(BuildContext ctx) {
    return showTimePicker(context: ctx, initialTime: TimeOfDay.now());
  }

  void showColorPicker(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => currentColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final argument =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text("Set Event"),
        actions: [
          TextButton.icon(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final List<Event> eventsList = [];
                  final totalDays = DateTime.parse(toDateController.text)
                      .difference(DateTime.parse(fromDateController.text));
                  for (var count = 0; count <= totalDays.inDays; count++) {
                    final from = DateTime.parse(fromDateController.text).add(
                        Duration(
                            days: count,
                            hours:
                                startTimeController.text.split(" ")[1] == "PM"
                                    ? int.parse(startTimeController.text
                                            .split(":")[0]) +
                                        12
                                    : int.parse(
                                        startTimeController.text.split(":")[0]),
                            minutes: int.parse(startTimeController.text
                                .split(":")[1]
                                .split(" ")[0])));
                    final to = DateTime.parse(fromDateController.text)
                        .add(
                            Duration(
                                days: count,
                                hours: endTimeController.text
                                            .split(" ")[1] ==
                                        "PM"
                                    ? int.parse(endTimeController.text
                                            .split(":")[0]) +
                                        12
                                    : int.parse(
                                        endTimeController.text.split(":")[0]),
                                minutes: int.parse(endTimeController.text
                                    .split(":")[1]
                                    .split(" ")[0])));
                    final event = Event(
                      title: titleController.text,
                      description: eventDescriptionController.text,
                      from: from,
                      to: to,
                      backgroundColor: currentColor,
                    );
                    eventsList.add(event);
                  }
                  Provider.of<EventProvider>(context, listen: false)
                      .addEventList(eventsList);
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.done),
              label: const Text('Save'))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value!.length < 3) {
                        return "Please enter a long event title";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: const Text("Event Title"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 10)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (!(argument[0] == CalendarApp.pageName))
                    TextFormField(
                      readOnly: true,
                      controller: fromDateController,
                      validator: (value) {
                        if (value == null) {
                          return "Please enter a valid date";
                        }
                        return null;
                      },
                      onTap: () {
                        datePicker(context).then((value) {
                          if (value != null) {
                            fromDateController.text =
                                DateFormat("yyyy-MM-dd").format(value);
                            toDateController.text =
                                DateFormat("yyyy-MM-dd").format(value);
                          }
                        });
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                          label: const Text("Event Date"),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              gapPadding: 10)),
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (argument[0] == CalendarApp.pageName)
                    Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(5),
                          child: TextFormField(
                            readOnly: true,
                            controller: fromDateController,
                            validator: (value) {
                              if (value == null) {
                                return "Please enter a valid date";
                              }
                              return null;
                            },
                            onTap: () {
                              datePicker(context).then((value) => value == null
                                  ? ''
                                  : fromDateController.text =
                                      DateFormat("yyyy-MM-dd").format(value));
                            },
                            decoration: InputDecoration(
                                label: const Text("From Date"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 10)),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.45,
                          margin: const EdgeInsets.all(5),
                          child: TextFormField(
                            readOnly: true,
                            controller: toDateController,
                            validator: (value) {
                              if (value == null) {
                                return "Please enter a valid date";
                              }
                              return null;
                            },
                            onTap: () {
                              datePicker(context).then((value) => value == null
                                  ? ''
                                  : toDateController.text =
                                      DateFormat("yyyy-MM-dd").format(value));
                            },
                            decoration: InputDecoration(
                                label: const Text("To Date"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    gapPadding: 10)),
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        margin: const EdgeInsets.all(5),
                        child: TextFormField(
                          readOnly: true,
                          controller: startTimeController,
                          validator: (value) {
                            if (value == null) {
                              return "Please enter a valid time";
                            }
                            return null;
                          },
                          onTap: () {
                            timePicker(context).then((value) => value == null
                                ? ''
                                : startTimeController.text =
                                    value.format(context));
                          },
                          decoration: InputDecoration(
                              label: const Text("Start Time"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 10)),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.45,
                        margin: const EdgeInsets.all(5),
                        child: TextFormField(
                          readOnly: true,
                          controller: endTimeController,
                          validator: (value) {
                            if (value == null) {
                              return "Please enter a valid time";
                            }
                            return null;
                          },
                          onTap: () {
                            timePicker(context).then((value) {
                              value == null
                                  ? ''
                                  : endTimeController.text =
                                      value.format(context);
                              FocusScope.of(context)
                                  .requestFocus(focusEventDescription);
                            });
                          },
                          decoration: InputDecoration(
                              label: const Text("End Time"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  gapPadding: 10)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    maxLength: 1000,
                    controller: eventDescriptionController,
                    focusNode: focusEventDescription,
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return "Please enter a long description";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        label: const Text("Event Description"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            gapPadding: 10)),
                  ),
                  Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5),
                      child: const Text(
                        "Event Color:",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => showColorPicker(context),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: currentColor,
                      ),
                    )
                  ])
                ],
              )),
        ),
      ),
    );
  }
}
