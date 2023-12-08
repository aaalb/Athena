// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      nome: fields[0] as String?,
      cognome: fields[1] as String?,
      matricola: fields[2] as String?,
      email: fields[3] as String?,
      dataNascita: fields[4] as String?,
      facolta: fields[5] as String?,
      role: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.cognome)
      ..writeByte(2)
      ..write(obj.matricola)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.dataNascita)
      ..writeByte(5)
      ..write(obj.facolta)
      ..writeByte(6)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
