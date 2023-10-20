import 'package:hive/hive.dart';

part 'employee.g.dart';

@HiveType(typeId: 0)
class Employee {
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;
  @HiveField(2)
  String surname;
  @HiveField(3)
  String job;
  @HiveField(4)
  DateTime birthDate;
  @HiveField(5)
  String arrivalTime;
  @HiveField(6)
  String departureTime;

  Employee({
    required this.id,
    required this.name,
    required this.surname,
    required this.job,
    required this.birthDate,
    required this.arrivalTime,
    required this.departureTime,
  });
}
