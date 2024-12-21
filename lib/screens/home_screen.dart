import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/providers/auth_provider.dart';
import 'package:instructor_auto/providers/user_provider.dart';
import 'package:instructor_auto/providers/student_provider.dart';
import 'package:instructor_auto/widgets/student_card.dart';
import 'package:instructor_auto/widgets/section_header.dart';

// Sample data model for a lesson
class DrivingLesson {
  final String studentName;
  final String time;
  final String location;
  final String lessonType;
  final String duration;

  DrivingLesson({
    required this.studentName,
    required this.time,
    required this.location,
    required this.lessonType,
    required this.duration,
  });
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final studentsAsync = ref.watch(studentListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.read(studentListProvider.notifier).refresh();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with user info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 25,
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user?.name}',
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Text(
                                    'Auto 1234',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        color: Colors.white,
                        icon: const Icon(Icons.menu),
                        itemBuilder: (BuildContext context) {
                          return [
                            const PopupMenuItem(
                              value: 'settings',
                              child: Text('Setări'),
                            ),
                            PopupMenuItem(
                              value: 'logout',
                              onTap: () => ref.read(authProvider.notifier).logout(),
                              child: const Text('Deconectare'),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text('Programare ședință'),
                        icon: const Icon(Icons.add),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text('Afișare calendar'),
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  ),

                  // Today's Lessons Section
                  const SectionHeader(title: "Ședințele de astăzi"),
                  const Text("No lessons for today"),

                  const SizedBox(height: 24),

                  // Future Lessons Section
                  const SectionHeader(title: "Ședințele viitoare"),
                  const Text("No future lessons"),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: const Text('Adaugă elev'),
                        icon: const Icon(Icons.add),
                      ),
                      TextButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/students'),
                        label: const Text('Listă elevi'),
                        icon: const Icon(Icons.people_alt_outlined),
                      ),
                    ],
                  ),

                  // Active Students Section
                  SectionHeader(title: "Elevi activi", onMorePressed: () => Navigator.pushNamed(context, '/students')),
                  studentsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stackTrace) => Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text(
                              error.toString(),
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => ref.read(studentListProvider.notifier).refresh(),
                              child: const Text('Încearcă din nou'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    data: (students) => students.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Text('Nu există elevi activi'),
                            ),
                          )
                        : Column(
                            children: students.map((student) => StudentCard(student: student)).toList(),
                          ),
                  ),

                  const SizedBox(height: 25),
                  // Version number
                  const Center(
                    child: Text(
                      'v0.0.1 beta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
