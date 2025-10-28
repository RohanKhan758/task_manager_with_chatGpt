// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_status_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskStatusCountImpl _$$TaskStatusCountImplFromJson(
        Map<String, dynamic> json) =>
    _$TaskStatusCountImpl(
      id: json['_id'] as String,
      sum: (json['sum'] as num).toInt(),
    );

Map<String, dynamic> _$$TaskStatusCountImplToJson(
        _$TaskStatusCountImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'sum': instance.sum,
    };
