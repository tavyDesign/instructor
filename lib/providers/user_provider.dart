import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/models/user.dart';
import 'package:instructor_auto/services/shared_preferences_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(null) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = SharedPreferencesService();
    final user = await prefs.getUser();
    state = user;
  }

  void setUser(User user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}
