// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final int typeId = 1;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: fields[0] as String,
      personId: fields[1] as String,
      personName: fields[2] as String,
      amount: fields[3] as double,
      paidAmount: fields[4] as double,
      type: fields[5] as DebtType,
      description: fields[6] as String,
      createdAt: fields[7] as DateTime,
      updatedAt: fields[8] as DateTime?,
      isSettled: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.personId)
      ..writeByte(2)
      ..write(obj.personName)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.paidAmount)
      ..writeByte(5)
      ..write(obj.type)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.isSettled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DebtTypeAdapter extends TypeAdapter<DebtType> {
  @override
  final int typeId = 0;

  @override
  DebtType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DebtType.iOwe;
      case 1:
        return DebtType.owedToMe;
      default:
        return DebtType.iOwe;
    }
  }

  @override
  void write(BinaryWriter writer, DebtType obj) {
    switch (obj) {
      case DebtType.iOwe:
        writer.writeByte(0);
        break;
      case DebtType.owedToMe:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
