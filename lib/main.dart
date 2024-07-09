import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_72_permission/provider/travel_provider.dart';
import 'package:lesson_72_permission/services/location_services.dart';
import 'package:lesson_72_permission/views/screen/home_screen.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await LocationService.init();

  final status = await [
    Permission.location,
    Permission.camera,
  ].request();
  print(status);

  // var cameraPermission = await Permission.camera.status;
  // var locationPermission = await Permission.location.status;
  //
  // if (locationPermission == PermissionStatus.denied) {
  //   locationPermission = await Permission.location.request();
  //   print(locationPermission);

// if (
// cameraPermission == PermissionStatus.denied) {
// cameraPermission = await Permission.camera.request();
// print(cameraPermission);
//
// }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TravelProvider()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
