import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/services/api/api_service.dart';
import 'package:instructor_auto/providers/api_provider.dart';

final studentListProvider = AsyncNotifierProvider<StudentListNotifier, List<Student>>(() {
  return StudentListNotifier();
});

class StudentListNotifier extends AsyncNotifier<List<Student>> {
  late final ApiService _apiService;
  //late final SharedPreferencesService _prefsService;

  @override
  Future<List<Student>> build() async {
    _apiService = ref.read(apiServiceProvider);
    //_prefsService = SharedPreferencesService();
    return _fetchStudents();
  }

  Future<List<Student>> _fetchStudents() async {
    try {
      final response = await _apiService.get('/student/list/');

      debugPrint('error $response');

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to fetch students');
      }

      final List<dynamic> studentsData = response.data['data']['students'];
      return studentsData.map((data) => Student.fromJson(data)).toList();
    } catch (error) {
      String errorMessage;
      if (error is DioException) {
        errorMessage = switch (error.type) {
          DioExceptionType.connectionTimeout => 'Connection timeout. Please check your internet connection.',
          DioExceptionType.receiveTimeout => 'Server is not responding. Please try again.',
          DioExceptionType.badResponse => error.response?.data?['message'] ?? 'Server error occurred.',
          DioExceptionType.unknown when error.error is SocketException => 'No internet connection. Please check your network.',
          _ => 'Network error occurred. Please try again.',
        };
      } else {
        errorMessage = error.toString().replaceAll('Exception: ', '');
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final students = await _fetchStudents();
      state = AsyncValue.data(students);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
