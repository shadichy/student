// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generator.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SampleTimetableAdapter extends TypeAdapter<SampleTimetable> {
  @override
  final int typeId = 12;

  @override
  SampleTimetable read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SampleTimetable(
      (fields[0] as List).cast<SubjectCourse>(),
    );
  }

  @override
  void write(BinaryWriter writer, SampleTimetable obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.courses)
      ..writeByte(1)
      ..write(obj.intMatrix);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SampleTimetableAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
