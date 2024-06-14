// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmSettingsAdapter extends TypeAdapter<AlarmSettings> {
  @override
  final int typeId = 11;

  @override
  AlarmSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmSettings(
      id: fields[0] as int,
      dateTime: fields[2] as DateTime,
      timeout: fields[12] as Duration,
      title: fields[8] as String,
      body: fields[9] as String,
      audio: fields[3] as String?,
      enabled: fields[1] as bool,
      loopAudio: fields[4] as bool,
      vibrate: fields[5] as bool,
      volume: fields[6] as double?,
      fadeDuration: fields[7] as double,
      enableNotificationOnKill: fields[10] as bool,
      androidFullScreenIntent: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmSettings obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.enabled)
      ..writeByte(2)
      ..write(obj.dateTime)
      ..writeByte(3)
      ..write(obj.audio)
      ..writeByte(4)
      ..write(obj.loopAudio)
      ..writeByte(5)
      ..write(obj.vibrate)
      ..writeByte(6)
      ..write(obj.volume)
      ..writeByte(7)
      ..write(obj.fadeDuration)
      ..writeByte(8)
      ..write(obj.title)
      ..writeByte(9)
      ..write(obj.body)
      ..writeByte(10)
      ..write(obj.enableNotificationOnKill)
      ..writeByte(11)
      ..write(obj.androidFullScreenIntent)
      ..writeByte(12)
      ..write(obj.timeout);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
