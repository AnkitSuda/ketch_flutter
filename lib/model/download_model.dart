import 'package:equatable/equatable.dart';

import '../enum/status.dart';

/// Download model: Data class sent to client mapped to each download
class DownloadModel extends Equatable {
  /// Download URL sent by client
  final String url;

  /// Download Path sent by client
  final String path;

  /// Name of the file sent by client
  final String fileName;

  /// Optional tag for each download to group the download into category
  final String tag;

  /// Unique download id created by the combination of url, path and filename
  final int id;

  /// Optional headers sent when making API call for file download
  final Map<String, String> headers;

  /// First time in millisecond when download was queued into the database
  final int timeQueued;

  /// Current [Status] of the download
  final Status status;

  /// Total size of file in bytes
  final int total;

  /// Current download progress in int between 0 and 100
  final int progress;

  /// Current speed of download in bytes per second
  final double speedInBytePerMs;

  /// Last modified time of database for current download (any change updates the time)
  final int lastModified;

  /// ETag of the download file sent by API response headers
  final String eTag;

  /// Optional metaData set by client for adding any extra download info
  final String metaData;

  /// Failure reason for failed download
  final String failureReason;

  const DownloadModel({
    required this.url,
    required this.path,
    required this.fileName,
    required this.tag,
    required this.id,
    required this.headers,
    required this.timeQueued,
    required this.status,
    required this.total,
    required this.progress,
    required this.speedInBytePerMs,
    required this.lastModified,
    required this.eTag,
    required this.metaData,
    required this.failureReason,
  });

  factory DownloadModel.fromMap(Map<dynamic, dynamic> map) {
    return DownloadModel(
      url: map['url'],
      path: map['path'],
      fileName: map['fileName'],
      tag: map['tag'],
      id: map['id'],
      headers: Map<String, String>.from(map['headers']),
      timeQueued: map['timeQueued'],
      status: Status.values.firstWhere((e) => e.name == map['status']),
      total: map['total'],
      progress: map['progress'],
      speedInBytePerMs: (map['speedInBytePerMs'] as num).toDouble(),
      lastModified: map['lastModified'],
      eTag: map['eTag'],
      metaData: map['metaData'],
      failureReason: map['failureReason'],
    );
  }

  @override
  List<Object?> get props => [
    url,
    path,
    fileName,
    tag,
    id,
    headers,
    timeQueued,
    status,
    total,
    progress,
    speedInBytePerMs,
    lastModified,
    eTag,
    metaData,
    failureReason,
  ];
}
