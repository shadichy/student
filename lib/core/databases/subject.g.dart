// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseSubjectAdapter extends TypeAdapter<BaseSubject> {
  @override
  final int typeId = 0;

  @override
  BaseSubject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseSubject(
      subjectID: fields[0] as String,
      subjectAltID: fields[1] as String?,
      name: fields[2] as String,
      cred: fields[3] as int,
      coef: fields[5] as double,
      dependencies: (fields[4] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, BaseSubject obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.subjectID)
      ..writeByte(1)
      ..write(obj.subjectAltID)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.cred)
      ..writeByte(4)
      ..write(obj.dependencies)
      ..writeByte(5)
      ..write(obj.coef);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseSubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
