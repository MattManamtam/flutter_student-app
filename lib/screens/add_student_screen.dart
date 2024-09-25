import 'package:flutter/material.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

class AddStudentScreen extends StatefulWidget {
  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _courseController;
  String _selectedYear = 'First Year';
  bool _isEnrolled = false;
  bool _isSubmitting = false;  // To track submission state

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _courseController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Student', style: TextStyle(color: Colors.white)),
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
              onPressed: _isSubmitting
                  ? null  // Disable button if submitting
                  : () {
                      setState(() {
                        _isSubmitting = true;  // Disable the button
                      });

                      Student newStudent = Student(
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        course: _courseController.text,
                        year: _selectedYear,
                        enrolled: _isEnrolled,
                      );

                      // Call API to create student and then pop back with true
                      ApiService().createStudent(newStudent).then((_) {
                        Navigator.pop(context, true);  // Return true to indicate a new student was added
                      }).catchError((error) {
                        // Handle error, show message, and enable the button again
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Failed to add student. Please try again.'),
                        ));
                        setState(() {
                          _isSubmitting = false;  // Enable the button again
                        });
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubmitting ? Colors.grey : Colors.green,  // Grey when disabled, green otherwise
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,  // Add some shadow
              ),
              child: _isSubmitting
                  ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))  // Show loader
                  : Text('Add Student', style: TextStyle(color: Colors.white)),
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
