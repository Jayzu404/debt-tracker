import 'package:hive/hive.dart';

part 'person_model.g.dart';

@HiveType(typeId: 4)
class PersonModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? phoneNumber;

  @HiveField(3)
  String? email;

  @HiveField(4)
  DateTime createdAt;

  PersonModel({
    required this.id,
    required this.name,
    this.phoneNumber,
    this.email,
    required this.createdAt,
  });

  PersonModel copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    DateTime? createdAt,
  }) {
    return PersonModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}