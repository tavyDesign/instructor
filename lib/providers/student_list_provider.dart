import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/providers/api_provider.dart';

final studentListProvider = StateNotifierProvider<StudentListNotifier, AsyncValue<List<Student>>>((ref) {
  return StudentListNotifier(ref);
});

class StudentListNotifier extends StateNotifier<AsyncValue<List<Student>>> {
  final Ref ref;

  StudentListNotifier(this.ref) : super(const AsyncValue.loading()) {
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response = await ref.read(apiServiceProvider).get(
        '/student/list/',
        queryParameters: {
          'page': 1,
          'per_page': 5,
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to fetch students');
      }

      final List<dynamic> studentsData = response.data['data']['students'];
      final students = studentsData.map((data) => Student.fromJson(data)).toList();
      state = AsyncValue.data(students);
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
      state = AsyncValue.error(errorMessage, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _fetchStudents();
  }

  void addStudents(List<Student> newStudents) {
    state.whenData((students) {
      state = AsyncValue.data([...students, ...newStudents]);
    });
  }
}
