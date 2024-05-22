// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotifAdapter extends TypeAdapter<Notif> {
  @override
  final int typeId = 7;

  @override
  Notif read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Notif(
      fields[0] as String,
      content: fields[1] as String,
      uploadDate: fields[2] as DateTime?,
      applyEvent: fields[3] as EventTimeline?,
      applyDates: (fields[4] as List?)?.cast<DateTime>(),
      applyGroup: fields[5] as UserGroup?,
      applySemester: fields[6] as UserSemester?,
      override: fields[7] as bool?,
      applied: fields[8] as bool?,
      read: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Notif obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.uploadDate)
      ..writeByte(3)
      ..write(obj.applyEvent)
      ..writeByte(4)
      ..write(obj.applyDates)
      ..writeByte(5)
      ..write(obj.applyGroup)
      ..writeByte(6)
      ..write(obj.applySemester)
      ..writeByte(7)
      ..write(obj.override)
      ..writeByte(8)
      ..write(obj.applied)
      ..writeByte(9)
      ..write(obj.read);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
