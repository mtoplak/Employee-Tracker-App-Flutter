import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String surname;
  @HiveField(2)
  final String job;
  @HiveField(3)
  final DateTime birthDate;
  @HiveField(4)
  final String arrivalTime;
  @HiveField(5)
  final String departureTime;

  Employee({
    required this.name,
    required this.surname,
    required this.job,
    required this.birthDate,
    required this.arrivalTime,
    required this.departureTime,
  });
}
