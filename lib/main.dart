import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/screens/student_details_screen.dart';
import 'package:instructor_auto/services/shared_preferences_service.dart';
import 'package:instructor_auto/screens/students_list_screen.dart';
import 'package:instructor_auto/widgets/auth_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService().init();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: 'Instructor Auto',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthChecker(),
        routes: {
          // Add routes here
          '/login': (context) => const AuthChecker(),
          '/students': (context) => const StudentsListScreen(),
          '/student-details': (context) => const StudentDetailsScreen(),
        },
      ),
    ),
  );
}
