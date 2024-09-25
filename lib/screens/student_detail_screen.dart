import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class StudentDetailScreen extends StatefulWidget {
  final Student student;

  StudentDetailScreen({required this.student});

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _courseController;
  String _selectedYear = 'First Year';
  bool _isEnrolled = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.student.firstName);
    _lastNameController = TextEditingController(text: widget.student.lastName);
    _courseController = TextEditingController(text: widget.student.course);
    _selectedYear = widget.student.year;
    _isEnrolled = widget.student.enrolled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.student.firstName} ${widget.student.lastName}',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade700, Colors.greenAccent.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              ApiService().deleteStudent(widget.student.id!).then((_) {
                Navigator.pop(context, true);  // Return true to indicate a change
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: 20),  // Add space between elements
            _buildTextField(_firstNameController, 'First Name'),
            SizedBox(height: 20),  // Space between fields
            _buildTextField(_lastNameController, 'Last Name'),
            SizedBox(height: 20),  // Space between fields
            _buildTextField(_courseController, 'Course'),
            SizedBox(height: 20),  // Space between fields
            _buildDropdown(),
            SizedBox(height: 20),  // Space between fields
            SwitchListTile(
              title: Text('Enrolled'),
              value: _isEnrolled,
              onChanged: (bool value) {
                setState(() {
                  _isEnrolled = value;
                });
              },
              activeColor: Colors.green,
            ),
            SizedBox(height: 30),  // More space above the button
            ElevatedButton(
              onPressed: () {
                Student updatedStudent = Student(
                  id: widget.student.id,
                  firstName: _firstNameController.text,
                  lastName: _lastNameController.text,
                  course: _courseController.text,
                  year: _selectedYear,
                  enrolled: _isEnrolled,
                );
                ApiService().updateStudent(widget.student.id!, updatedStudent).then((_) {
                  Navigator.pop(context, true);  // Return true to indicate a change
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,  // Green color for the button
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,  // Add some shadow
              ),
              child: Text('Update Student', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.green),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.greenAccent),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<String>(
      value: _selectedYear,
      onChanged: (String? newValue) {
        setState(() {
          _selectedYear = newValue!;
        });
      },
      items: ['First Year', 'Second Year', 'Third Year', 'Fourth Year', 'Fifth Year']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      dropdownColor: Colors.green.shade50,
      underline: Container(
        height: 2,
        color: Colors.green,
      ),
    );
  }
}
