import 'package:hive/hive.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 0)
enum DebtType {
  @HiveField(0)
  iOwe,
  
  @HiveField(1)
  owedToMe,
}

@HiveType(typeId: 1)
class DebtModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String personId;

  @HiveField(2)
  String personName;

  @HiveField(3)
  double amount;

  @HiveField(4)
  double paidAmount;

  @HiveField(5)
  DebtType type;

  @HiveField(6)
  String description;

  @HiveField(7)
  DateTime createdAt;

  @HiveField(8)
  DateTime? updatedAt;

  @HiveField(9)
  bool isSettled;

  DebtModel({
    required this.id,
    required this.personId,
    required this.personName,
    required this.amount,
    this.paidAmount = 0.0,
    required this.type,
    this.description = '',
    required this.createdAt,
    this.updatedAt,
    this.isSettled = false,
  });

  double get remainingAmount => amount - paidAmount;
  bool get isFullyPaid => paidAmount >= amount;

  DebtModel copyWith({
    String? id,
    String? personId,
    String? personName,
    double? amount,
    double? paidAmount,
    DebtType? type,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSettled,
  }) {
    return DebtModel(
      id: id ?? this.id,
      personId: personId ?? this.personId,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      type: type ?? this.type,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSettled: isSettled ?? this.isSettled,
    );
  }
}