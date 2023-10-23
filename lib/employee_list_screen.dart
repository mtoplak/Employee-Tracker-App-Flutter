import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/employee.dart';
import 'package:intl/intl.dart';

class EmployeeListScreen extends StatelessWidget {
  final Box<Employee> employeesBox = Hive.box<Employee>('employees');
  String? selectedJob;
  DateTime? selectedBirthDate;
  String? selectedArrivalTime;
  String? selectedDepartureTime;

  EmployeeListScreen({super.key});

  void editEmployee(BuildContext context, int index) {
    final employee = employeesBox.getAt(index);

    TextEditingController nameController =
        TextEditingController(text: employee?.name);
    TextEditingController surnameController =
        TextEditingController(text: employee?.surname);

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Edit Employee'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: surnameController,
                      decoration: const InputDecoration(labelText: 'Surname'),
                    ),
                    DropdownButtonFormField<String>(
                      value: employee?.job,
                      onChanged: (newValue) {
                        selectedJob = newValue;
                      },
                      items: <String>[
                        'Hišnik',
                        'Vodja',
                        'Prodajalec',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration:
                          const InputDecoration(labelText: 'Delovno mesto'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: employee?.birthDate ?? DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            employee?.birthDate = date;
                          });
                        }
                      },
                      child: Text(selectedBirthDate != null
                          ? 'Datum rojstva: ${DateFormat('yyyy-MM-dd').format(selectedBirthDate!)}'
                          : 'Datum rojstva: ${DateFormat('yyyy-MM-dd').format(employee!.birthDate)}'),
                    ),
                    TextButton(
                        onPressed: () async {
                          debugPrint(employee?.arrivalTime);
                          final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: employee?.arrivalTime != null
                                  ? TimeOfDay(
                                      hour: int.parse(employee!.arrivalTime
                                          .split(":")[0]
                                          .split("(")[1]),
                                      minute: int.parse(employee.arrivalTime
                                          .split(":")[1]
                                          .split(")")[0]),
                                    )
                                  : TimeOfDay.now());
                          if (selectedTime != null) {
                            setState(() {
                              selectedArrivalTime = selectedTime.toString();
                            });
                          }
                        },
                        child: Text(
                          selectedArrivalTime != null
                              ? 'Ura prihoda: ${selectedArrivalTime?.split(":")[0].split("(")[1]}:${selectedArrivalTime?.split(":")[1].split(")")[0]}'
                              : 'Ura prihoda: ${employee?.arrivalTime.split(":")[0].split("(")[1]}:${employee?.arrivalTime.split(":")[1].split(")")[0]}',
                        )),
                    TextButton(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                              context: context,
                              initialTime: employee?.departureTime != null
                                  ? TimeOfDay(
                                      hour: int.parse(employee!.departureTime
                                          .split(":")[0]
                                          .split("(")[1]),
                                      minute: int.parse(employee.departureTime
                                          .split(":")[1]
                                          .split(")")[0]),
                                    )
                                  : TimeOfDay.now());
                          if (selectedTime != null) {
                            setState(() {
                              selectedDepartureTime = selectedTime.toString();
                            });
                          }
                        },
                        child: Text(
                          selectedDepartureTime != null
                              ? 'Ura odhoda: ${selectedDepartureTime?.split(":")[0].split("(")[1]}:${selectedDepartureTime?.split(":")[1].split(")")[0]}'
                              : 'Ura odhoda: ${employee?.departureTime.split(":")[0].split("(")[1]}:${employee?.departureTime.split(":")[1].split(")")[0]}',
                        )),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (employee != null) {
                        Employee updatedEmployee = Employee(
                          id: employee.id,
                          name: nameController.text,
                          surname: surnameController.text,
                          job: selectedJob ?? employee.job,
                          birthDate: employee.birthDate,
                          arrivalTime: employee.arrivalTime,
                          departureTime: employee.departureTime,
                        );

                        onEmployeeUpdated(index, updatedEmployee);
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              );
            },
          );
        });
  }

  // Callback to update the employee in the database
  void onEmployeeUpdated(int index, Employee updatedEmployee) {
    final employeeKey = employeesBox.keyAt(index);
    employeesBox.put(employeeKey, updatedEmployee);
  }

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
          return employees.isNotEmpty
              ? ListView.builder(
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return ListTile(
                      onTap: () {
                        editEmployee(context, index);
                      },
                      title: Text('${employee.name} ${employee.surname}'),
                      subtitle: Text(employee.job),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_forever),
                        onPressed: () {
                          final employeeKey = employeesBox.keyAt(index);
                          debugPrint(employeeKey.toString());
                          employeesBox.delete(employeeKey);
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Successfully Deleted'),
                                content: const Text(
                                    'The employee has been deleted.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No employees'),
                );
        },
      ),
    );
  }
}
