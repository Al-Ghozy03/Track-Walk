// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/events.dart';
import 'package:track_walk_admin/screen/tickets.dart';
import 'package:track_walk_admin/screen/login.dart';
import 'package:track_walk_admin/screen/qr_scanner.dart';
import 'package:track_walk_admin/service/api_service.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          brightness: Brightness.light,
          fontFamily: "popin",
          colorScheme: ThemeData().colorScheme.copyWith(primary: greenTheme)),
      darkTheme: ThemeData(
          fontFamily: "popin",
          brightness: Brightness.dark,
          scaffoldBackgroundColor: bgDark),
      themeMode: ThemeMode.system,
      title: 'TrackWalk',
      home: storage.read("auth") == null ? Login() : Event(),
      builder: EasyLoading.init(),
    );
  }
}
