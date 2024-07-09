import 'package:flutter/material.dart';
import 'package:lesson_72_permission/views/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../data/model/travel_model.dart';
import '../../provider/travel_provider.dart';

class EditTravelScreen extends StatefulWidget {
  final String travelId;
  final Map<String, dynamic> travelData;

  EditTravelScreen({required this.travelId, required this.travelData});

  @override
  _EditTravelScreenState createState() => _EditTravelScreenState();
}

class _EditTravelScreenState extends State<EditTravelScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late String _photoPath;
  late String _location;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.travelData['title']);
    _photoPath = widget.travelData['photo'];
    _location = widget.travelData['location'];
  }

  @override
  Widget build(BuildContext context) {
    final travelProvider = Provider.of<TravelProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Travel'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                onPressed: () async {
                  await travelProvider.pickPhoto();
                  setState(() {
                    _photoPath = travelProvider.photoPath!;
                  });
                },
                child: Text('Pick Photo'),
              ),
              if (_photoPath.isNotEmpty)
                Image.file(File(_photoPath)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await travelProvider.getLocation();
                  setState(() {
                    _location = travelProvider.location!;
                  });
                },
                child: Text('Get Location'),
              ),
              if (_location.isNotEmpty)
                Text('Location: $_location'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedTravel = Travel(
                      id: widget.travelId,
                      title: _titleController.text,
                      photo: _photoPath,
                      location: _location,
                    );
                    travelProvider.editTravel(widget.travelId, updatedTravel, context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                      return HomeScreen();
                    },),);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
