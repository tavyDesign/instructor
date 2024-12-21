import 'package:flutter/material.dart';
import 'package:instructor_auto/utils/time_formatter.dart';
import 'package:instructor_auto/utils/quiz_status_colors.dart';

class CustomQuizTable extends StatelessWidget {
  final List<dynamic> quizzes;
  final Map<String, dynamic> pagination;
  final Function(int) onPageChange;
  final bool isLoading;
  final String category;

  const CustomQuizTable({
    super.key,
    required this.quizzes,
    required this.pagination,
    required this.onPageChange,
    required this.isLoading,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuizzes = category == 'B' ? 26 : 20;
    return Column(
      children: [
        // Table Header
        Table(
          columnWidths: const {
            0: FlexColumnWidth(2), // Date column wider
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text('Dată', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Text('Total', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Icon(Icons.check_circle_sharp, size: 18, color: Colors.green),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    child: Text(
                      'Ajutor',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Table Body
        if (quizzes.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(child: Text('Nu există date disponibile')),
          )
        else
          Stack(
            children: [
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                children: quizzes.map((quiz) {
                  return TableRow(
                    decoration: BoxDecoration(
                      color: getQuizStatusColor(
                        category: category,
                        total: quiz['numar_raspunsuri'],
                        correct: quiz['raspunsuri_corecte'],
                        wrong: quiz['raspunsuri_gresite'],
                        help: quiz['ajutor_folosit'],
                      ), //Colors.greenAccent.withValues(alpha: 0.1),
                      border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                    ),
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            formatTimeAgo(quiz['time']),
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            '${quiz['numar_raspunsuri'].toString()}/$totalQuizzes',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            quiz['raspunsuri_corecte'].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            quiz['raspunsuri_gresite'].toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              quiz['ajutor_folosit'].toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            if (quiz['raspunsuri_gresite'] > 0)
                              PopupMenuButton(
                                  style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                                  color: Colors.white,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        value: 'details',
                                        child: Text('Vezi întrebările greșite'),
                                      ),
                                    ];
                                  }),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              if (isLoading) Positioned(top: 0, left: 0, right: 0, bottom: 0, child: Center(child: CircularProgressIndicator())),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text('Semnificația culorilor chestionarelor:'),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.square, size: 26, color: Colors.greenAccent.withValues(alpha: 0.25)),
                      Text('Admis', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.square, size: 26, color: Colors.redAccent.withValues(alpha: 0.25)),
                      Text('Respins', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.square, size: 26, color: Colors.yellow.withValues(alpha: 0.25)),
                      Text('Admis cu ajutor', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        // Pagination Controls
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Page Info
              Text(
                'Pagina ${pagination['current_page']} din ${pagination['total_pages']} (${pagination['total_count']} chestionare)',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10.0),
              // Pagination Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: pagination['current_page'] > 1 && !isLoading ? () => onPageChange(pagination['current_page'] - 1) : null,
                    label: Text('Anterioarele'),
                    icon: const Icon(Icons.arrow_back, size: 16),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: pagination['has_next'] && !isLoading ? () => onPageChange(pagination['current_page'] + 1) : null,
                    label: Text('Următoarele'),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    iconAlignment: IconAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
