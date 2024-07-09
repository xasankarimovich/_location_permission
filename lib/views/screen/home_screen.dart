import 'package:flutter/material.dart';
import 'package:lesson_72_permission/views/screen/travel_screen.dart';
import 'package:location/location.dart';

import '../../data/model/travel_model.dart';
import '../../services/location_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  LocationData? myLocation;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await LocationService.fetchCurrentLocation();

      setState(() {
        myLocation = LocationService.currentLocation;
      });

      LocationService.fetchLiveLocation().listen((location) {
        setState(() {
          myLocation = location;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TravelModel(),
    );
  }
}