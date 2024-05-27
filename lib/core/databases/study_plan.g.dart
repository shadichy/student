// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'study_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SemesterPlanAdapter extends TypeAdapter<SemesterPlan> {
  @override
  final int typeId = 8;

  @override
  SemesterPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SemesterPlan(
      semester: fields[0] as int,
      timetableInt:
          (fields[1] as List).map((dynamic e) => (e as List).cast<int>()),
      studyWeeks: (fields[2] as List).cast<int>(),
      startDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SemesterPlan obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.semester)
      ..writeByte(1)
      ..write(obj.timetableInt.toList())
      ..writeByte(2)
      ..write(obj.studyWeeks)
      ..writeByte(3)
      ..write(obj.startDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SemesterPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
