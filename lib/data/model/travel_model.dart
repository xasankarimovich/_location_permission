import 'package:lesson_72_permission/data/constant/key_constant.dart';

class Travel {
  final String id;
  final String title;
  final String photo;
  final String location;

  Travel({
    required this.id,
    required this.title,
    required this.photo,
    required this.location,
  });

  Map<String, dynamic> toMap() {
    return {
      FirebaseConstantKey.id: id,
      FirebaseConstantKey.title: title,
      FirebaseConstantKey.travelPhoto: photo,
      FirebaseConstantKey.travelLocation: location,
    };
  }
}
