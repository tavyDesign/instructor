import 'package:flutter/material.dart';

class TopWrongAnswers extends StatelessWidget {
  final List<dynamic>? wrongAnswers;
  final String category;

  const TopWrongAnswers({
    super.key,
    required this.wrongAnswers,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    if (wrongAnswers == null || wrongAnswers!.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('Nu există întrebări greșite'),
          ),
        ),
      );
    }

    return Column(
      children: (wrongAnswers as List).map((question) {
        // Parse base64 image if exists
        Widget? imageWidget;
        if (question['image_url'] != null) {
          imageWidget = Image.network(
            question['image_url'],
            errorBuilder: (context, error, stackTrace) {
              return const Center(
                child: Text('Imaginea nu poate fi încărcată'),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }

        return Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  question['question'],
                  style: const TextStyle(
                    fontSize: 16.00,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: ExpansionTile(
                  backgroundColor: Colors.white,
                  title: Text('Greșită de ${question['mistake_count']} ori'),
                  children: [
                    if (imageWidget != null) imageWidget,
                    Card(
                      color: question['answers']['A']['is_correct'] ? Colors.greenAccent : Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'A',
                              style: TextStyle(fontSize: 25.00),
                            ),
                          ],
                        ),
                        title: Text(question['answers']['A']['text']),
                      ),
                    ),
                    Card(
                      color: question['answers']['B']['is_correct'] ? Colors.greenAccent : Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'B',
                              style: TextStyle(fontSize: 25.00),
                            ),
                          ],
                        ),
                        title: Text(question['answers']['B']['text']),
                      ),
                    ),
                    Card(
                      color: question['answers']['C']['is_correct'] ? Colors.greenAccent : Colors.white,
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'C',
                              style: TextStyle(fontSize: 25.00),
                            ),
                          ],
                        ),
                        title: Text(question['answers']['C']['text']),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'Răspuns corect: ',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              _buildCorrectAnswersString(question['answers']),
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _buildCorrectAnswersString(Map<String, dynamic> answers) {
    List<String> correctAnswers = [];
    if (answers['A']['is_correct']) correctAnswers.add('A');
    if (answers['B']['is_correct']) correctAnswers.add('B');
    if (answers['C']['is_correct']) correctAnswers.add('C');
    return correctAnswers.join(' ');
  }
}
