import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class QuizDataSource extends DataTableSource {
  final List<dynamic> quizzes;
  final int totalRows;
  final bool isLastPage;

  QuizDataSource({
    required this.quizzes,
    required this.totalRows,
    required this.isLastPage,
  });

  @override
  DataRow? getRow(int index) {
    if (index >= quizzes.length) return null;
    final quiz = quizzes[index];
    timeago.setLocaleMessages('ro', timeago.RoMessages());
    timeago.setLocaleMessages('ro_short', timeago.RoShortMessages());

    return DataRow(
      cells: [
        DataCell(Text(timeago.format(DateTime.parse(quiz['time']), locale: 'ro'))),
        DataCell(Text(quiz['numar_raspunsuri'].toString())),
        DataCell(Text(quiz['raspunsuri_corecte'].toString())),
        DataCell(Text(quiz['raspunsuri_gresite'].toString())),
        DataCell(Text(quiz['ajutor_folosit'].toString())),
      ],
    );
  }

  void addData(List<dynamic> newQuizzes) {
    quizzes.addAll(newQuizzes);
    notifyListeners();
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => quizzes.length;

  @override
  int get selectedRowCount => 0;
}
