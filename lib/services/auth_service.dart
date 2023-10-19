import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zoubida/config/auth_api_config.dart';


class AuthService{
  late String authUrl;
  late String apiHost;
  late int apiPort;
  late String apiUrl;

  AuthService({String? authUrl, String ?apiHost, int ?apiPort, String ?apiUrl}){
    this.authUrl = authUrl ?? AuthApiConfig.authUrl;
    this.apiHost = apiHost ?? AuthApiConfig.apiHost;
    this.apiPort = apiPort ?? AuthApiConfig.apiPort;
    this.apiUrl = apiUrl ?? AuthApiConfig.apiUrl;
  }

  Future<Response> registerUser(Object data) async {
    print(data);
    Response response = await post(
      Uri(scheme: "http", path: "$authUrl/register", host: apiHost, port: apiPort),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    return response;
  }

  Future<Response> login(Object formData) async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    Response response = await post(
      Uri(scheme: "http", path: "$authUrl/login", host: apiHost, port: apiPort),
      headers: <String,String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(formData)
    );

    if(response.statusCode == 200 && response.body.isNotEmpty){
      Map<String, dynamic> responseBody = jsonDecode(response.body);

      Map<String, dynamic> credentials = {
        'id': responseBody['id']!,
        'email': responseBody['email']!,
        'role': responseBody['role']!,
      };
      storage.setString('credentials', jsonEncode(credentials));
      storage.setBool('isLoggedIn', true);
    }
    return response;
  }

  void logout() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    print(storage.get('credentials'));

    storage.remove('credentials');
    storage.remove('isLoggedIn');
  }
}


