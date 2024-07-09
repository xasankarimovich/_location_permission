import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../data/model/travel_model.dart';
import '../services/firebase_storage.dart';

class TravelProvider extends ChangeNotifier {
  String? _photoPath;
  String? _location;

  String? get photoPath => _photoPath;
  String? get location => _location;

  void setPhotoPath(String path) {
    _photoPath = path;
    notifyListeners();
  }

  void setLocation(String loc) {
    _location = loc;
    notifyListeners();
  }

  Future<void> pickPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setPhotoPath(image.path);
    }
  }

  Future<void> getLocation() async {
    final Location location = Location();
    final LocationData locationData = await location.getLocation();
    setLocation('${locationData.latitude}, ${locationData.longitude}');
  }

  Future<void> saveTravelToFirebase(Travel travel, BuildContext context) async {
    final CollectionReference travels = FirebaseFirestore.instance.collection('travels');
    final FirebaseStorageServices storageServices = FirebaseStorageServices();

    if (_photoPath != null) {
      final File file = File(_photoPath!);
      final String? photoUrl = await storageServices.uploadFile(travel.id, file);
      if (photoUrl != null) {
        travel = Travel(
          id: travel.id,
          title: travel.title,
          photo: photoUrl,
          location: travel.location,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload photo')));
        return;
      }
    }
    try {
      await travels.add(travel.toMap());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save travel: $e')));
    }
  }

  Future<void> editTravel(String id, Travel travel, BuildContext context) async {
    final CollectionReference travels = FirebaseFirestore.instance.collection('travels');
    try {
      await travels.doc(id).update(travel.toMap());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel updated successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update travel: $e')));
    }
  }

  Future<void> deleteTravel(String id, BuildContext context) async {
    final CollectionReference travels = FirebaseFirestore.instance.collection('travels');
    try {
      await travels.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Travel deleted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete travel: $e')));
    }
  }

  Stream<QuerySnapshot> getTravelsStream() {
    return FirebaseFirestore.instance.collection('travels').snapshots();
  }
}
