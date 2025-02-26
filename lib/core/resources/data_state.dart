import 'package:dio/dio.dart';

abstract class DataState<T> {
  final T? data;
  final DioException? exception;

  const DataState(this.data, this.exception);
}

class DataSuccess<T> extends DataState<T> {
  const DataSuccess(T data) : super(data, data as DioException?);
}

class DataError<T> extends DataState<T> {
  const DataError(T error) : super(error, error as DioException?);
}
