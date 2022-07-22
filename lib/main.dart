// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/events.dart';
import 'package:track_walk_admin/screen/qr_scanner.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Track Walk',
        theme: ThemeData(
            fontFamily: "popin",
            colorScheme: ThemeData().colorScheme.copyWith(primary: blueTheme)),
        home: Event());
  }
}
