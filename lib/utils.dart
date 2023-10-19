import 'dart:convert';

import 'package:flutter/services.dart';

class Utils{
   static Future<List> readJson(String filePath) async {
    final String response = await rootBundle.loadString('assets/sample.json');
    final data = await json.decode(response);
    return data["items"];
  }
}