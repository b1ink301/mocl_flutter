import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class Result extends Equatable {
  @override
  List<Object?> get props => [];
}

class ResultFailure<T> extends Result {
  final T failure;

  ResultFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

class ResultInitial extends Result {}

class ResultLoading extends Result {}

class ResultSuccess<T> extends Result {
  final T data;

  ResultSuccess({required this.data});

  @override
  List<Object?> get props => [data];
}
