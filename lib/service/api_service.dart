// ignore_for_file: unused_import, prefer_const_declarations, prefer_interpolation_to_compose_strings, prefer_final_fields, unused_field, avoid_print

import 'dart:convert';
import 'dart:developer';
import 'package:alert/alert.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:track_walk_admin/screen/events.dart';
import '../screen/detail_tiket.dart';
import 'getx_service.dart';

final storage = GetStorage();

class ApiService {
  String baseUrl = "https://track-dev.xplorin.id/wp-json/fooevents/v1";
  static final String _login = "login_status";
  String consumerKey = "ck_74c41e69516b18c05e84f8993331c49aca073c16";
  String consumerSecret = "cs_6d9b38145bd9cc8e55bb999d04a1a4ab0ceb450c";
  String _event = "/get_list_of_events";
  String _ticket = "/get_tickets_in_event";
  String _singleTicket = "/get_single_ticket";
  String _param2 = "?param2";

  // Future event() async {
  //   final res = await http.get(Uri.parse("$baseUrl" + "$_event"));
  //   if (res.statusCode == 200) {
  //     return eventModelFromJson(res.body);
  //   } else {
  //     return false;
  //   }
  // }

  Future ticket(id) async {
    Uri urlApi = Uri.parse(baseUrl + _ticket + "$_param2=$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "username": "tracktix",
      "password": "wYSLQ7jdN8k3(iO#6oyq7x9G"
    };
    final res = await http.post(urlApi, headers: requestHeaders);

    // print(res);
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return false;
    }
  }

  Future event() async {
    final res =
        await http.post(Uri.parse("$baseUrl/get_list_of_events"), headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "username": "tracktix",
      "password": "wYSLQ7jdN8k3(iO#6oyq7x9G",
    });
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      return false;
    }
  }

  Future singleTicket(id) async {
    Uri urlApi = Uri.parse(baseUrl + _singleTicket + "$_param2=$id");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      "username": "tracktix",
      "password": "wYSLQ7jdN8k3(iO#6oyq7x9G"
    };
    final res = await http.post(urlApi, headers: requestHeaders);

    // print(res);
    if (res.statusCode == 200) {
      log("hai");
      print(urlApi);

      true;
      return jsonDecode(res.body);
    } else {
      return false;
    }
  }

  Future login(String username, String password, String url) async {
    Uri urlApi = Uri.parse(baseUrl + "/$_login");
    Map<String, String> requestHeaders = {
      'Content-type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    };
    final response = await http.post(
      urlApi,
      body: jsonEncode({
        "url": url,
        "username": username.toLowerCase(),
        "password": password,
      }),
      headers: requestHeaders,
    );
    if (response.statusCode == 400) {
      Alert(
              message: jsonDecode(response.body)["error_description"],
              shortDuration: true)
          .show();
      return false;
    }
    if (response.statusCode == 200) {
      print(response.statusCode);
      storage.write("token", jsonDecode(response.body)["jwt_token"]);
      // ignore: prefer_const_constructors
      Get.off(Event());
      return true;
    } else {
      print(response.body);

      return false;
    }
  }
}
