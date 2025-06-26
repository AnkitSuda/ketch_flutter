import 'dart:async';

import 'package:ketch_flutter/model/download_config.dart';
import 'package:ketch_flutter/model/download_model.dart';
import 'package:ketch_flutter/model/notification_config.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ketch_flutter_platform.dart';

class KetchFlutter implements PlatformInterface {
  KetchFlutter._internal();

  static final KetchFlutter _instance = KetchFlutter._internal();

  factory KetchFlutter() => _instance;
  final StreamController<List<DownloadModel>> _eventStreamController =
      StreamController.broadcast();
  StreamSubscription? _eventSub;

  Future<void> cancel({int? id, String? tag}) =>
      KetchFlutterPlatform.instance.cancel(id: id, tag: tag);

  Future<void> cancelAll() => KetchFlutterPlatform.instance.cancelAll();

  Future<void> clearAllDb({bool deleteFile = true}) =>
      KetchFlutterPlatform.instance.clearAllDb(deleteFile: deleteFile);

  Future<void> clearDb({int? id, String? tag, bool deleteFile = true}) =>
      KetchFlutterPlatform.instance.clearDb(
        id: id,
        tag: tag,
        deleteFile: deleteFile,
      );

  Future<int?> download({
    required String url,
    required String path,
    String? fileName,
    String tag = "",
    String metaData = "",
    Map<String, String> headers = const {},
    bool supportPauseResume = true,
    String? customNotificationTitle,
  }) => KetchFlutterPlatform.instance.download(
    url: url,
    path: path,
    fileName: fileName,
    tag: tag,
    metaData: metaData,
    headers: headers,
    supportPauseResume: supportPauseResume,
    customNotificationTitle: customNotificationTitle,
  );

  Future<List<DownloadModel>> getDownloadModels({
    int? id,
    String? tag,
    String? status,
    List<String>? ids,
    List<String>? tags,
    List<String>? statuses,
  }) => KetchFlutterPlatform.instance
      .getDownloadModels(
        id: id,
        tag: tag,
        status: status,
        ids: ids,
        tags: tags,
        statuses: statuses,
      )
      .then((List<dynamic>? result) {
        if (result == null) {
          return [];
        }
        return result
            .map((dynamic item) => DownloadModel.fromMap(item))
            .toList();
      });

  Future<DownloadModel?> getDownloadModelById(int id) =>
      getDownloadModels(id: id).then((items) => items.firstOrNull);

  Future<void> pause({int? id, String? tag}) =>
      KetchFlutterPlatform.instance.pause(id: id, tag: tag);

  Future<void> pauseAll() => KetchFlutterPlatform.instance.pauseAll();

  Future<void> resume({
    int? id,
    String? tag,
    String? customNotificationTitle,
  }) => KetchFlutterPlatform.instance.resume(
    id: id,
    tag: tag,
    customNotificationTitle: customNotificationTitle,
  );

  Future<void> resumeAll() => KetchFlutterPlatform.instance.resumeAll();

  Future<void> retry({int? id, String? tag}) =>
      KetchFlutterPlatform.instance.retry(id: id, tag: tag);

  Future<void> retryAll() => KetchFlutterPlatform.instance.retryAll();

  Future<void> setup({
    bool enableLogs = true,
    DownloadConfig? downloadConfig,
    NotificationConfig? notificationConfig,
  }) async {
    _setupEventStream();

    await KetchFlutterPlatform.instance.setup(
      enableLogs: enableLogs,
      downloadConfig: downloadConfig,
      notificationConfig: notificationConfig,
    );
  }

  void _setupEventStream() {
    _eventSub?.cancel();
    _eventSub = KetchFlutterPlatform.instance.getEventStream().listen((data) {
      if (data is List<dynamic>) {
        final models =
            data.map((dynamic item) => DownloadModel.fromMap(item)).toList();

        _eventStreamController.add(models);
      }
    });
  }

  Stream<List<DownloadModel>> get eventStream => _eventStreamController.stream;
}
