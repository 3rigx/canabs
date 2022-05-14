import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/helpers/utils.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventPage extends StatefulWidget {
  SubCategory? subCategory;

  EventPage({Key? key}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final eventAdd = FirebaseFirestore.instance.collection('event');
  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    widget.subCategory = catSelection.selectedSubCategory;
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          MainAppBar(
            themeColor: Colors.white,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                height: screenSize.height - 50,
                width: screenSize.width,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: eventAdd
                      .doc(widget.subCategory!.name)
                      .collection(widget.subCategory!.name!)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          'Something went Wrong, Check Data Connecton',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (!snapshot.hasData) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/images/chat_icon.png'),
                            const Text(
                              'No Events Created.  ☺️😊',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    var data = snapshot.data!.docs;

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: const Icon(
                              Icons.event,
                              size: 16,
                              color: AppColors.Secondary_color,
                            ),
                            title: Text(
                              "${data[index]['Title']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              "${data[index]['Details']} Starts : ${data[index]['Starts']} Ends : ${data[index]['Ends']}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            isThreeLine: true,
                            onLongPress: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Wrap(
                                      children: [
                                        ListTile(
                                            leading: const Icon(Icons.delete),
                                            title: const Text('Delete'),
                                            onTap: () => {
                                                  FirebaseFirestore.instance
                                                      .runTransaction((Transaction
                                                          transaction) async {
                                                    transaction.delete(snapshot
                                                        .data!
                                                        .docs[index]
                                                        .reference);
                                                    Navigator.pop(context);
                                                  }),
                                                })
                                      ],
                                    );
                                  });
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Utils.mainAppNav.currentState!.pushNamed('/eventAdd');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
