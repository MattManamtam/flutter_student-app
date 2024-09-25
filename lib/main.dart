import 'package:flutter/material.dart';
import 'screens/student_list_screen.dart'; // Import your main screen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'Student Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Define the home route (starting screen)
      home: StudentListScreen(),
      routes: {
        '/studentList': (context) => StudentListScreen(), // Define routes for navigation
        // You can add more routes as needed, for example, to add a new student or view student details
      },
    );
  }
}
