import 'package:flutter/material.dart';
import 'models/employee.dart';

class EmployeeListScreen extends StatelessWidget {
  final List<Employee> employees;

  const EmployeeListScreen({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text('${employee.name} ${employee.surname}'), //dialog widget
            // subtitle: Text(employee.job),
          );
        },
      ),
    );
  }
}
