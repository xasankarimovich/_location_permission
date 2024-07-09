import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../data/model/travel_model.dart';
import '../../provider/travel_provider.dart';

class TravelModel extends StatefulWidget {
  @override
  _TravelModelState createState() => _TravelModelState();
}

class _TravelModelState extends State<TravelModel> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Travel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => travelProvider.pickPhoto(),
                    child: Text('Pick Photo'),
                  ),
                  if (travelProvider.photoPath != null)
                    Image.file(File(travelProvider.photoPath!)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => travelProvider.getLocation(),
                    child: Text('Get Location'),
                  ),
                  if (travelProvider.location != null)
                    Text('Location: ${travelProvider.location}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final travel = Travel(
                          id: DateTime.now().toString(),
                          title: _titleController.text,
                          photo: travelProvider.photoPath ?? '',
                          location: travelProvider.location ?? '',
                        );
                        travelProvider.saveTravelToFirebase(travel, context);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Save Travel'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: travelProvider.getTravelsStream(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No travels found.'));
                  }

                  // Display travels in a GridView
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var travelDoc = snapshot.data!.docs[index];
                      var travelData = travelDoc.data() as Map<String, dynamic>;
                      return Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                travelData['photo'], fit: BoxFit.cover,
                              ),
                            ),
                            Text(travelData['title']),
                            Text(travelData['location']),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => EditTravelScreen(travel: Travel(
                                    //       id: travelDoc.id,
                                    //       title: travelData['title'],
                                    //       photo: travelData['photo'],
                                    //       location: travelData['location'],
                                    //     )),
                                    //   ),
                                    // );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    travelProvider.deleteTravel(travelDoc.id, context);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
