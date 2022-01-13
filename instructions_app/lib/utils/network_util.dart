import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';

class NetworkUtil {
  // next three lines makes this class a Singleton
  static NetworkUtil _instance = new NetworkUtil.internal();
  NetworkUtil.internal();
  factory NetworkUtil() => _instance;

  final JsonDecoder _decoder = new JsonDecoder();

  Future<dynamic> get(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('itoken') ?? ""); 
    print("Token:$token");   
    return await http.get(url,headers: { HttpHeaders.authorizationHeader: "bearer $token"},).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
  Future<dynamic> delete(String url) async {
    return await http.delete(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode != 200|| json == null) {
        throw new Exception("Error while deleting data");
      }
      return _decoder.convert(res);
    });
  }
  Future<dynamic> post(String url, {Map headers, body, encoding}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString('itoken') ?? ""); 
    print("Token:$token");   
    return await http
        .post(url, body: body,
         headers: { HttpHeaders.authorizationHeader: "bearer $token"},
         encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

// Future<dynamic> checkUser(String url,String username, String password) async {
//   final http.Response response = await http.post(
//     url,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//      'UserName': username,
//       'Password': password
//     }),
//   );
// return response;
 
// }
  }