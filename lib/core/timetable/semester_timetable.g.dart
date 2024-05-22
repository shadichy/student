// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'semester_timetable.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeekTimetableAdapter extends TypeAdapter<WeekTimetable> {
  @override
  final int typeId = 9;

  @override
  WeekTimetable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeekTimetable(
      (fields[1] as List).cast<EventTimestamp>(),
      startDate: fields[0] as DateTime,
      weekNo: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WeekTimetable obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.weekNo)
      ..writeByte(1)
      ..write(obj.timestamps);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeekTimetableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
