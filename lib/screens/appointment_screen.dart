import 'package:flutter/material.dart';

//create class statfull widget AppointmentScreen

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  //create state class _AppointmentScreenState
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text("Detalii programare"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //create a container with the text "Programari"
            Text("Nume elev", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: [
                    Text('Data:'),
                    SizedBox(height: 10),
                    Text('Locația:'),
                  ],
                ),
                Column(
                  children: [
                    Text('01.01.2022 ora 10:00'),
                    SizedBox(height: 10),
                    Text('Parcare McDonalds'),
                  ],
                ),
              ],
            ),

            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Programari viitoare",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //create a container with the text "Programari viitoare"
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Programari viitoare",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
