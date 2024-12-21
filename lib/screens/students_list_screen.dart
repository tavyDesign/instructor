import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/providers/student_list_provider.dart';
import 'package:instructor_auto/widgets/student_card.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/providers/api_provider.dart';

class StudentsListScreen extends ConsumerStatefulWidget {
  const StudentsListScreen({super.key});

  @override
  ConsumerState<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends ConsumerState<StudentsListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !_isLoadingMore && _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final response = await ref.read(apiServiceProvider).get(
        '/student/list/',
        queryParameters: {
          'page': _currentPage + 1,
          'per_page': 5,
        },
      );

      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to fetch more students');
      }

      final pagination = response.data['data']['pagination'];
      final newStudents = (response.data['data']['students'] as List).map((data) => Student.fromJson(data)).toList();

      if (mounted) {
        setState(() {
          ref.read(studentListProvider.notifier).addStudents(newStudents);
          _hasMore = pagination['has_next'] ?? false;
          _currentPage = pagination['current_page'];
          _isLoadingMore = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await ref.read(studentListProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(studentListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.grey[100],
        title: const Text('Elevi activi'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: studentsAsync.when(
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
                  onPressed: _refresh,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
          data: (students) => students.isEmpty
              ? const Center(
                  child: Text('No students found'),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: students.length + (_hasMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == students.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final student = students[index];
                    return StudentCard(student: student);
                  },
                ),
        ),
      ),
    );
  }
}
