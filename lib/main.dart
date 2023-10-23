import 'package:flutter/material.dart';
import 'package:rvir_flutter/employee_list_screen.dart';
import 'package:rvir_flutter/models/employee.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EmployeeAdapter());
  await Hive.openBox<Employee>('employees');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee tracking app',
      theme: ThemeData(
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmployeeEntryScreen(),
    );
  }
}

class EmployeeEntryScreen extends StatefulWidget {
  const EmployeeEntryScreen({super.key});

  @override
  _EmployeeEntryScreenState createState() => _EmployeeEntryScreenState();
}

class _EmployeeEntryScreenState extends State<EmployeeEntryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  String? selectedJob;
  DateTime? selectedBirthDate;
  TimeOfDay? selectedArrivalTime;
  TimeOfDay? selectedDepartureTime;

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  Future<void> _addEmployee() async {
    if (nameController.text.isNotEmpty &&
        surnameController.text.isNotEmpty &&
        selectedJob != null &&
        selectedBirthDate != null &&
        selectedArrivalTime != null &&
        selectedDepartureTime != null) {
      final employeesBox = Hive.box<Employee>('employees');
      int highestId = 0;

      if (employeesBox.isNotEmpty) {
        highestId =
            employeesBox.keys.cast<int>().reduce((a, b) => a > b ? a : b);
      }

      // Increment the highestId to get the next available ID
      int nextEmployeeId = highestId + 1;

      final newEmployee = Employee(
        id: nextEmployeeId,
        name: nameController.text,
        surname: surnameController.text,
        job: selectedJob!,
        birthDate: selectedBirthDate!,
        arrivalTime: selectedArrivalTime.toString(),
        departureTime: selectedDepartureTime.toString(),
      );

      employeesBox.add(newEmployee);

      setState(() {
        nameController.clear();
        surnameController.clear();
        selectedJob = null;
        selectedBirthDate = null;
        selectedArrivalTime = null;
        selectedDepartureTime = null;
      });
      _navigateToEmployeeList();
      _showSuccessDialog();
    }
  }

  void _navigateToEmployeeList() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmployeeListScreen(),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Employee has been added.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vnos zaposlenih 👷‍♂️'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Ime'),
                  ),
                  TextField(
                    controller: surnameController,
                    decoration: const InputDecoration(labelText: 'Priimek'),
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedJob,
                    onChanged: (newValue) {
                      setState(() {
                        selectedJob = newValue;
                      });
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
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          selectedBirthDate = selectedDate;
                        });
                      }
                    },
                    child: Text(selectedBirthDate != null
                        ? 'Datum rojstva: ${DateFormat('yyyy-MM-dd').format(selectedBirthDate!)}'
                        : 'Datum rojstva'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        setState(() {
                          selectedArrivalTime = selectedTime;
                        });
                      }
                    },
                    child: Text(selectedArrivalTime != null
                        ? 'Ura prihoda: ${selectedArrivalTime!.format(context)}'
                        : 'Ura prihoda'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (selectedTime != null) {
                        setState(() {
                          selectedDepartureTime = selectedTime;
                        });
                      }
                    },
                    child: Text(selectedDepartureTime != null
                        ? 'Ura odhoda: ${selectedDepartureTime!.format(context)}'
                        : 'Ura odhoda'),
                  ),
                  ElevatedButton(
                    onPressed: _addEmployee,
                    child: const Text('Dodaj zaposlenega'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity, // Make it full width
            child: ElevatedButton(
              onPressed: _navigateToEmployeeList,
              child: const Text('Prikaži seznam zaposlenih'),
            ),
          ),
        ],
      ),
    );
  }
}
