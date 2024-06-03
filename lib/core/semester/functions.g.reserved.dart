// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functions.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventTimestampAdapter extends TypeAdapter<EventTimestamp> {
  @override
  final int typeId = 1;

  @override
  EventTimestamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventTimestamp(
      eventName: fields[0] as String,
      intStamp: fields[1] as int,
      dayOfWeek: fields[2] as int,
      location: fields[3] as String?,
      heldBy: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EventTimestamp obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.intStamp)
      ..writeByte(2)
      ..write(obj.dayOfWeek)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.heldBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTimestampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CourseTimestampAdapter extends TypeAdapter<CourseTimestamp> {
  @override
  final int typeId = 2;

  @override
  CourseTimestamp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CourseTimestamp.fromHive(
      courseID: fields[0] as String,
      intStamp: fields[1] as int,
      dayOfWeek: fields[2] as int,
      room: fields[3] as String,
      teacherID: fields[4] as String,
      timestampTypeInt: fields[5] as int,
      courseTypeInt: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CourseTimestamp obj) {
    writer
      ..writeByte(7)
      ..writeByte(5)
      ..write(obj.timestampTypeInt)
      ..writeByte(6)
      ..write(obj.courseTypeInt)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.intStamp)
      ..writeByte(2)
      ..write(obj.dayOfWeek)
      ..writeByte(3)
      ..write(obj.location)
      ..writeByte(4)
      ..write(obj.heldBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CourseTimestampAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTimelineAdapter extends TypeAdapter<EventTimeline> {
  @override
  final int typeId = 3;

  @override
  EventTimeline read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventTimeline(
      label: fields[0] as String,
      timestamp: (fields[1] as List).cast<EventTimestamp>(),
    );
  }

  @override
  void write(BinaryWriter writer, EventTimeline obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTimelineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SchoolEventAdapter extends TypeAdapter<SchoolEvent> {
  @override
  final int typeId = 4;

  @override
  SchoolEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SchoolEvent(
      label: fields[0] as String,
      timestamp: (fields[1] as List).cast<EventTimestamp>(),
      title: fields[2] as String?,
      desc: fields[3] as String?,
      days: (fields[4] as List).cast<DateTime>(),
    );
  }

  @override
  void write(BinaryWriter writer, SchoolEvent obj) {
    writer
      ..writeByte(5)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.desc)
      ..writeByte(4)
      ..write(obj.days)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchoolEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectCourseAdapter extends TypeAdapter<SubjectCourse> {
  @override
  final int typeId = 5;

  @override
  SubjectCourse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubjectCourse(
      courseID: fields[0] as String,
      timestamp: (fields[1] as List).cast<CourseTimestamp>(),
      subjectID: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubjectCourse obj) {
    writer
      ..writeByte(3)
      ..writeByte(2)
      ..write(obj.subjectID)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectCourseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 10;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      subjectID: fields[0] as String,
      subjectAltID: fields[1] as String?,
      name: fields[2] as String,
      cred: fields[3] as int,
      coef: fields[5] as double,
      dependencies: (fields[4] as List).cast<String>(),
      courses: (fields[6] as Map).cast<String, SubjectCourse>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(7)
      ..writeByte(6)
      ..write(obj.courses)
      ..writeByte(5)
      ..write(obj.coef)
      ..writeByte(0)
      ..write(obj.subjectID)
      ..writeByte(1)
      ..write(obj.subjectAltID)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.cred)
      ..writeByte(4)
      ..write(obj.dependencies);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
