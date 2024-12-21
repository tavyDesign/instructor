import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/providers/student_details_provider.dart';
import 'package:instructor_auto/providers/api_provider.dart';
import 'package:instructor_auto/widgets/custom_quiz_table.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/widgets/top_wrong_answers.dart';

class StudentDetailsScreen extends ConsumerStatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  ConsumerState<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends ConsumerState<StudentDetailsScreen> {
  late String studentId;

  bool isLoading = false;

  Future<void> _loadQuizzes(String studentId, int page) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ref.read(apiServiceProvider).get(
        '/student/quiz/list/',
        queryParameters: {
          'id': studentId,
          'page': page + 1,
          'per_page': 10,
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to fetch quizzes');
      }

      // Get current student data
      final currentStudent = ref.read(studentDetailsProvider(studentId)).value;
      if (currentStudent == null) return;

      // Create new student with only updated quizzes and pagination
      final updatedStudent = Student(
        id: currentStudent.id,
        email: currentStudent.email,
        name: currentStudent.name,
        appId: currentStudent.appId,
        status: currentStudent.status,
        category: currentStudent.category,
        addedAt: currentStudent.addedAt,
        statistics: currentStudent.statistics,
        passRate: currentStudent.passRate,
        totalQuestionsResolved: currentStudent.totalQuestionsResolved,
        totalTests: currentStudent.totalTests,
        lastAnswerTime: currentStudent.lastAnswerTime,
        quizzes: response.data['data']['quizzes'] as List<dynamic>,
        quizPagination: response.data['data']['pagination'] as Map<String, dynamic>,
      );

      // Update the provider state
      ref.read(studentDetailsProvider(studentId).notifier).state = AsyncValue.data(updatedStudent);

      setState(() {
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    studentId = ModalRoute.of(context)!.settings.arguments as String;
    final studentAsync = ref.watch(studentDetailsProvider(studentId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text('Detalii elev'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          return ref.read(studentDetailsProvider(studentId).notifier).refresh();
        },
        child: studentAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    ref.read(studentDetailsProvider(studentId).notifier).refresh();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
          data: (student) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Information Card
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Basic Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        InfoRow(label: 'Name', value: student.name),
                        InfoRow(label: 'Email', value: student.email),
                        if (student.appId != null) InfoRow(label: 'App ID', value: student.appId.toString()),
                        InfoRow(
                          label: 'Status',
                          value: student.status == 1 ? 'Active' : 'Inactive',
                        ),
                        InfoRow(
                          label: 'Added At',
                          value: student.addedAt.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Statistics Card
                if (student.statistics)
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          InfoRow(
                            label: 'Pass Rate',
                            value: '${student.passRate.toStringAsFixed(1)}%',
                          ),
                          InfoRow(
                            label: 'Total Tests',
                            value: student.totalTests.toString(),
                          ),
                          InfoRow(
                            label: 'Questions Resolved',
                            value: student.totalQuestionsResolved.toString(),
                          ),
                          if (student.lastAnswerTime != null)
                            InfoRow(
                              label: 'Last Answer',
                              value: student.lastAnswerTime.toString(),
                            ),
                        ],
                      ),
                    ),
                  ),
                // Quiz History
                if (student.statistics) ...[
                  const SizedBox(height: 15.0),
                  const Text(
                    'Istoric chestionare',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 10.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomQuizTable(
                            quizzes: student.quizzes ?? [],
                            pagination: student.quizPagination ??
                                {
                                  'current_page': 1,
                                  'total_pages': 1,
                                  'total_count': 0,
                                  'has_next': false,
                                },
                            onPageChange: (page) => _loadQuizzes(studentId, page - 1),
                            isLoading: isLoading,
                            category: student.category,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (student.topWrongAnswers != null) ...[
                  const SizedBox(height: 15.0),
                  const Text(
                    'Top 10 întrebări greșite frecvent',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopWrongAnswers(
                        wrongAnswers: student.topWrongAnswers,
                        category: student.category,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
