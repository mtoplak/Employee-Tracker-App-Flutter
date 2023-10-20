import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/employee.dart';

class EmployeeListScreen extends StatelessWidget {
  final Box<Employee> employeesBox = Hive.box<Employee>('employees');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee List'),
      ),
      body: ValueListenableBuilder<Box<Employee>>(
        valueListenable: employeesBox.listenable(),
        builder: (context, box, _) {
          final employees = box.values.toList();
          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final employee = employees[index];
              return ListTile(
                title: Text('${employee.name} ${employee.surname}'),
                // subtitle: Text(employee.job),
              );
            },
          );
        },
      ),
    );
  }
}
