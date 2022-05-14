import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:canabs/wudgets/themebutton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Eventpage extends StatefulWidget {
  SubCategory? subCategory;

  Eventpage({Key? key}) : super(key: key);

  @override
  _EventpageState createState() => _EventpageState();
}

class _EventpageState extends State<Eventpage> {
  TextEditingController eventCont = TextEditingController();
  TextEditingController eventTitleCont = TextEditingController();
  String date = "";
  DateTime selectedDate = DateTime.now();
  DateTime todayDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String? startdate, enddate;

  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    widget.subCategory = catSelection.selectedSubCategory;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            MainAppBar(
              themeColor: Colors.white,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          controller: eventCont,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Event Details',
                            hintText: 'Enter event details',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextField(
                          controller: eventTitleCont,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Title',
                            hintText: 'Input Event Title',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: const Text('Pick Start Date'),
                      ),
                      Text(
                        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectEndDate(context);
                        },
                        child: const Text('Pick End Date'),
                      ),
                      Text(
                        "${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ThemeButton(
                        label: "Add New Event",
                        icon: const Icon(Icons.event_note),
                        onClick: () {
                          if (eventCont.text.length < 3 &&
                              eventTitleCont.text.length < 3) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    const Text('Input Event Details and Title'),
                                action: SnackBarAction(
                                  label: 'Ok',
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                  },
                                ),
                              ),
                            );
                          }
                          String sdate =
                              "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                          String eDate =
                              "${selectedEndDate.day}/${selectedEndDate.month}/${selectedEndDate.year}";

                          addEvent(
                            widget.subCategory!.name,
                            eventTitleCont.text,
                            eventCont.text,
                            sdate,
                            eDate,
                          );
                          eventTitleCont.clear();
                          eventCont.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Event Added'),
                              action: SnackBarAction(
                                label: 'Ok',
                                onPressed: () {
                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                },
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (selected != selectedDate) {
      setState(() {
        selectedDate = selected!;
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? selectedd = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2022),
    );
    if (selectedd != selectedDate) {
      setState(() {
        selectedEndDate = selectedd!;
      });
    }
  }

  Future<void> addEvent(
    String? cate,
    title,
    details,
    starts,
    ends,
  ) {
    CollectionReference event = FirebaseFirestore.instance.collection('event');
    return event.doc(cate).collection(cate!).add({
      'Title': title,
      'Details': details,
      'Starts': starts,
      'Ends': ends,
    });
  }
}
