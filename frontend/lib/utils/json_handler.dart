import 'package:punctualis_1/structures/task.dart';
import 'dart:convert';

abstract class JSONHandler {
  static Future<List<Task>> parseTasks(List<dynamic> rawData) async {
    return rawData.map((userJson) => Task.fromJson(userJson)).toList();
  }
}
