import 'package:flutter/material.dart';
import 'package:instructor_auto/models/student.dart';
import 'package:instructor_auto/utils/time_formatter.dart';
import 'package:timeago/timeago.dart' as timeago;

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ro', timeago.RoMessages());
    timeago.setLocaleMessages('ro_short', timeago.RoShortMessages());

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/student-details', arguments: student.id.toString());
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 15.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  student.statistics == true
                      ? Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Întrebări rezolvate:'),
                                  Text(
                                    '${student.totalQuestionsResolved}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Promovabilitate:'),
                                  Text(
                                    '${(student.passRate * 100).toStringAsFixed(0)}%',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: student.passRate,
                                backgroundColor: Colors.grey[300],
                                valueColor: (student.passRate <= 0.5)
                                    ? const AlwaysStoppedAnimation(Colors.red)
                                    : (student.passRate > 0.5 && student.passRate <= 0.85)
                                        ? const AlwaysStoppedAnimation(Colors.orange)
                                        : const AlwaysStoppedAnimation(Colors.green),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(student.lastAnswerTime != null ? formatTimeAgo(student.lastAnswerTime!) : 'N/A')
                                ],
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student.name,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text('Elevul nu este conectat cu aplicația de chestionare.'),
                            ],
                          ),
                        ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        const Text('Ședințe'),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                  backgroundColor: Colors.grey[300],
                                  value: 5 / 15,
                                ),
                              ),
                            ),
                            Center(
                                child: Text(
                              '5/15',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {},
                    label: Text('Programează ședință'),
                    icon: Icon(Icons.calendar_month),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
