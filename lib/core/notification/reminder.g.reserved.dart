// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 6;

  @override
  Reminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Reminder(
      fields[0] as int,
      fields[5] as int,
      disabled: fields[1] as bool?,
      vibrate: fields[2] as bool?,
      alarmMode: fields[3] as int?,
      audio: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj._scheduleDuration.inMinutes)
      ..writeByte(1)
      ..write(obj._disabled)
      ..writeByte(2)
      ..write(obj._vibrate)
      ..writeByte(3)
      ..write(obj._alarmMode)
      ..writeByte(4)
      ..write(obj._audio)
      ..writeByte(5)
      ..write(obj._ringDuration.inMinutes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
