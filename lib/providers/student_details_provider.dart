import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/providers/api_provider.dart';

final studentDetailsProvider = StateNotifierProvider.family<StudentDetailsNotifier, AsyncValue<Student>, String>(
  (ref, id) => StudentDetailsNotifier(ref, id),
);

class StudentDetailsNotifier extends StateNotifier<AsyncValue<Student>> {
  final Ref ref;
  final String studentId;

  StudentDetailsNotifier(this.ref, this.studentId) : super(const AsyncValue.loading()) {
    fetchStudentDetails();
  }

  Future<void> fetchStudentDetails() async {
    try {
      final response = await ref.read(apiServiceProvider).get('/student/', queryParameters: {'id': studentId});

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to fetch student details');
      }

      final studentData = response.data['data']['student'];
      final student = Student.fromJson(studentData);
      state = AsyncValue.data(student);
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
    await fetchStudentDetails();
  }
}
