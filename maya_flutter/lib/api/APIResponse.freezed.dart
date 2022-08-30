// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'APIResponse.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$APIResponse<T> {
  String get displayMessage => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? dummy, Response res, String displayMessage)
        error,
    required TResult Function(T body, String displayMessage) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(APIResponseError<T> value) error,
    required TResult Function(APIResponseSuccess<T> value) success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc

class _$APIResponseError<T> implements APIResponseError<T> {
  const _$APIResponseError(this.dummy, this.res, this.displayMessage);

  @override
  final T? dummy;
  @override
  final Response res;
  @override
  final String displayMessage;

  @override
  String toString() {
    return 'APIResponse<$T>.error(dummy: $dummy, res: $res, displayMessage: $displayMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$APIResponseError<T> &&
            const DeepCollectionEquality().equals(other.dummy, dummy) &&
            const DeepCollectionEquality().equals(other.res, res) &&
            const DeepCollectionEquality()
                .equals(other.displayMessage, displayMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(dummy),
      const DeepCollectionEquality().hash(res),
      const DeepCollectionEquality().hash(displayMessage));

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? dummy, Response res, String displayMessage)
        error,
    required TResult Function(T body, String displayMessage) success,
  }) {
    return error(dummy, res, displayMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
  }) {
    return error?.call(dummy, res, displayMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(dummy, res, displayMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(APIResponseError<T> value) error,
    required TResult Function(APIResponseSuccess<T> value) success,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class APIResponseError<T> implements APIResponse<T> {
  const factory APIResponseError(
          final T? dummy, final Response res, final String displayMessage) =
      _$APIResponseError<T>;

  T? get dummy;
  Response get res;
  @override
  String get displayMessage;
}

/// @nodoc

class _$APIResponseSuccess<T> implements APIResponseSuccess<T> {
  const _$APIResponseSuccess(this.body, this.displayMessage);

  @override
  final T body;
  @override
  final String displayMessage;

  @override
  String toString() {
    return 'APIResponse<$T>.success(body: $body, displayMessage: $displayMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$APIResponseSuccess<T> &&
            const DeepCollectionEquality().equals(other.body, body) &&
            const DeepCollectionEquality()
                .equals(other.displayMessage, displayMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(body),
      const DeepCollectionEquality().hash(displayMessage));

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(T? dummy, Response res, String displayMessage)
        error,
    required TResult Function(T body, String displayMessage) success,
  }) {
    return success(body, displayMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
  }) {
    return success?.call(body, displayMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(T? dummy, Response res, String displayMessage)? error,
    TResult Function(T body, String displayMessage)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(body, displayMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(APIResponseError<T> value) error,
    required TResult Function(APIResponseSuccess<T> value) success,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(APIResponseError<T> value)? error,
    TResult Function(APIResponseSuccess<T> value)? success,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class APIResponseSuccess<T> implements APIResponse<T> {
  const factory APIResponseSuccess(final T body, final String displayMessage) =
      _$APIResponseSuccess<T>;

  T get body;
  @override
  String get displayMessage;
}
