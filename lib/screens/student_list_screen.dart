import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';
import 'student_detail_screen.dart';
import 'add_student_screen.dart'; // Import the add student screen

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  late Future<List<Student>> _students;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  // Function to fetch students
  void _fetchStudents() {
    _students = ApiService().getStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: Text("Students", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade600, Colors.greenAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Student>>(
        future: _students,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load students',
                style: TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No students available',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final student = snapshot.data![index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: Colors.greenAccent.shade700,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    '${student.firstName} ${student.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                    student.course,
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.green.shade600),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentDetailScreen(student: student),
                      ),
                    );

                    // Reload students list if a student is updated or deleted
                    if (result == true) {
                      setState(() {
                        _fetchStudents(); // Re-fetch students
                      });
                    }
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () async {
          // Navigate to add student screen
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddStudentScreen(),
            ),
          );

          // Reload the students list if a new student was added
          if (result == true) {
            setState(() {
              _fetchStudents(); // Re-fetch students
            });
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: Colors.green.shade50,
    );
  }
}
