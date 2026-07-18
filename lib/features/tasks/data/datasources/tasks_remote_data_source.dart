import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/task_model.dart';

abstract class TasksRemoteDataSource {
  Future<List<TaskModel>> getTasks();
  Future<TaskModel> getTaskById(int id);
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  TasksRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/todos'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => TaskModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<TaskModel> getTaskById(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/todos/$id'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TaskModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load task');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
