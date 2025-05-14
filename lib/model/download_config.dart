import 'package:equatable/equatable.dart';
import 'package:ketch_flutter/constants.dart';

class DownloadConfig extends Equatable {
  final int? connectTimeOutInMs;
  final int? readTimeOutInMs;

  const DownloadConfig({
    this.connectTimeOutInMs = DEFAULT_VALUE_CONNECT_TIMEOUT_MS,
    this.readTimeOutInMs = DEFAULT_VALUE_READ_TIMEOUT_MS,
  });

  @override
  List<Object?> get props => [connectTimeOutInMs, readTimeOutInMs];
}
