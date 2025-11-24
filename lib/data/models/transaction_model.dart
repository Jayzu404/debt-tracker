import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
enum TransactionType {
  @HiveField(0)
  payment,
  
  @HiveField(1)
  received,
}

@HiveType(typeId: 3)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String debtId;

  @HiveField(2)
  String personName;

  @HiveField(3)
  double amount;

  @HiveField(4)
  TransactionType type;

  @HiveField(5)
  String note;

  @HiveField(6)
  DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.debtId,
    required this.personName,
    required this.amount,
    required this.type,
    this.note = '',
    required this.createdAt,
  });

  TransactionModel copyWith({
    String? id,
    String? debtId,
    String? personName,
    double? amount,
    TransactionType? type,
    String? note,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      debtId: debtId ?? this.debtId,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}