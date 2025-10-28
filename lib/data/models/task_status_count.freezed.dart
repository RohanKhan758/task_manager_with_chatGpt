// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_status_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TaskStatusCount _$TaskStatusCountFromJson(Map<String, dynamic> json) {
  return _TaskStatusCount.fromJson(json);
}

/// @nodoc
mixin _$TaskStatusCount {
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  int get sum => throw _privateConstructorUsedError;

  /// Serializes this TaskStatusCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TaskStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStatusCountCopyWith<TaskStatusCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatusCountCopyWith<$Res> {
  factory $TaskStatusCountCopyWith(
          TaskStatusCount value, $Res Function(TaskStatusCount) then) =
      _$TaskStatusCountCopyWithImpl<$Res, TaskStatusCount>;
  @useResult
  $Res call({@JsonKey(name: '_id') String id, int sum});
}

/// @nodoc
class _$TaskStatusCountCopyWithImpl<$Res, $Val extends TaskStatusCount>
    implements $TaskStatusCountCopyWith<$Res> {
  _$TaskStatusCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sum = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TaskStatusCountImplCopyWith<$Res>
    implements $TaskStatusCountCopyWith<$Res> {
  factory _$$TaskStatusCountImplCopyWith(_$TaskStatusCountImpl value,
          $Res Function(_$TaskStatusCountImpl) then) =
      __$$TaskStatusCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: '_id') String id, int sum});
}

/// @nodoc
class __$$TaskStatusCountImplCopyWithImpl<$Res>
    extends _$TaskStatusCountCopyWithImpl<$Res, _$TaskStatusCountImpl>
    implements _$$TaskStatusCountImplCopyWith<$Res> {
  __$$TaskStatusCountImplCopyWithImpl(
      _$TaskStatusCountImpl _value, $Res Function(_$TaskStatusCountImpl) _then)
      : super(_value, _then);

  /// Create a copy of TaskStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? sum = null,
  }) {
    return _then(_$TaskStatusCountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sum: null == sum
          ? _value.sum
          : sum // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TaskStatusCountImpl implements _TaskStatusCount {
  const _$TaskStatusCountImpl(
      {@JsonKey(name: '_id') required this.id, required this.sum});

  factory _$TaskStatusCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$TaskStatusCountImplFromJson(json);

  @override
  @JsonKey(name: '_id')
  final String id;
  @override
  final int sum;

  @override
  String toString() {
    return 'TaskStatusCount(id: $id, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatusCountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.sum, sum) || other.sum == sum));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, sum);

  /// Create a copy of TaskStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatusCountImplCopyWith<_$TaskStatusCountImpl> get copyWith =>
      __$$TaskStatusCountImplCopyWithImpl<_$TaskStatusCountImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TaskStatusCountImplToJson(
      this,
    );
  }
}

abstract class _TaskStatusCount implements TaskStatusCount {
  const factory _TaskStatusCount(
      {@JsonKey(name: '_id') required final String id,
      required final int sum}) = _$TaskStatusCountImpl;

  factory _TaskStatusCount.fromJson(Map<String, dynamic> json) =
      _$TaskStatusCountImpl.fromJson;

  @override
  @JsonKey(name: '_id')
  String get id;
  @override
  int get sum;

  /// Create a copy of TaskStatusCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStatusCountImplCopyWith<_$TaskStatusCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
