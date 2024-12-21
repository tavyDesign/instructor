import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/models/user.dart';
import 'package:instructor_auto/services/api/api_service.dart';
import 'package:instructor_auto/services/shared_preferences_service.dart';
import 'package:instructor_auto/config/app_config.dart';
import 'package:instructor_auto/providers/user_provider.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ApiService(), SharedPreferencesService(), ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  final ApiService _apiService;
  final SharedPreferencesService _prefsService;
  final Ref ref;

  AuthNotifier(this._apiService, this._prefsService, this.ref) : super(const AsyncValue.data(null)) {
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final user = await _prefsService.getUser();
    if (user != null) {
      ref.read(userProvider.notifier).setUser(user);
      state = AsyncValue.data(user);
    }
  }

  Future<void> login(String email, String password) async {
    try {
      state = const AsyncValue.loading();

      final response = await _apiService.post(
        AppConfig.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      if (response.data['status'] != 'success' || response.data['data'] == null) {
        throw Exception(response.data['message'] ?? 'Login failed');
      }

      final responseData = response.data['data'];
      final user = User.fromJson(responseData);

      // Save to SharedPreferences
      await _prefsService.saveToken(responseData['token']);
      await _prefsService.saveUser(user);

      // Update user provider
      ref.read(userProvider.notifier).setUser(user);

      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
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

      state = AsyncValue.error(errorMessage, stackTrace);
    }
  }

  Future<void> logout() async {
    await _prefsService.clearAll();
    ref.read(userProvider.notifier).clearUser();
    state = const AsyncValue.data(null);
  }
}
