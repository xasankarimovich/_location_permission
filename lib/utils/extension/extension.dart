import 'package:flutter/material.dart';

double width = 375;
double height = 812;

extension Size on num {
  //SizedBox height
  SizedBox boxH() => SizedBox(height: (this / 812) * height);
  //SizedBox width
  SizedBox boxW() => SizedBox(width: (this / 375) * width);

  double get h => (this / 812) * height;
  double get w => (this / 375) * width;
}

// MediaQuery orqali ekran o'lchamlarini olish uchun kengaytmalar
extension ContextExtension on BuildContext {
  double getWidth() {
    return MediaQuery.of(this).size.width;
  }

  double getHeight() {
    double appBarHeight = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(this).viewPadding.top;
    double screenHeight =
        MediaQuery.of(this).size.height - appBarHeight - statusBarHeight;
    return screenHeight;
  }
}


// date time ni format qilish faqat kun oy va vaqatni olish uchun

Map monthes = {
  "1": "Yanvar",
  "2": "Fevral",
  "3": "Mart",
  "4": "Aprel",
  "5": "May",
  "6": "Iyun",
  "7": "Iyul",
  "8": "Avgusts",
  "9": "Sentyabr",
  "10": "Oktyabr",
  "11": "Noyabr",
  "12": "Dekabr",
};
String time = "Am";

extension Date on DateTime {
  String dateFormatToString() {
    final day = this.day.toString().padLeft(2, "0");
    final month = monthes[this.month.toString()];
    int.parse(this.hour.toString()) > 12 ? time = "Pm" : time = "Am";
    final hour = int.parse(
              this.hour.toString(),
            ) <=
            12
        ? (this.hour.toString().padLeft(2, "0"),)
        : ((int.parse(this.hour.toString()) - 12).toString().padLeft(2, "0"));
    final minute = this.minute.toString().padLeft(2, "0");

    return "$month $day , $hour:$minute $time";
  }
}
