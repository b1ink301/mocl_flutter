import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<T> readJsonFromAssets<T>(String fileName) async {
  final jsonString = await rootBundle.loadString('assets/$fileName');
  return json.decode(jsonString);
}
