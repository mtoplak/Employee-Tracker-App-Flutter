import 'package:flutter/material.dart';
import 'package:rvir_flutter/main.dart';

class EmployeeListScreen extends StatelessWidget {
  final List<Employee> employees;

  EmployeeListScreen({required this.employees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text('${employee.name} ${employee.surname}'),
            // subtitle: Text(employee.job),
          );
        },
      ),
    );
  }
}
