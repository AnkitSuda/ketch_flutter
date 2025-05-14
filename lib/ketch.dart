import 'package:ketch_flutter/model/download_config.dart';
import 'package:ketch_flutter/model/download_model.dart';
import 'package:ketch_flutter/model/notification_config.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ketch_flutter_platform.dart';

class KetchFlutter implements PlatformInterface {
  KetchFlutter._internal();

  static final KetchFlutter _instance = KetchFlutter._internal();

  factory KetchFlutter() => _instance;

  Future<void> cancel({String? id, String? tag}) =>
      KetchFlutterPlatform.instance.cancel(id: id, tag: tag);

  Future<void> cancelAll() => KetchFlutterPlatform.instance.cancelAll();

  Future<void> clearAllDb({bool deleteFile = true}) =>
      KetchFlutterPlatform.instance.clearAllDb(deleteFile: deleteFile);

  Future<void> clearDb({String? id, String? tag, bool deleteFile = true}) =>
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
  }) => KetchFlutterPlatform.instance.download(
    url: url,
    path: path,
    fileName: fileName,
    tag: tag,
    metaData: metaData,
    headers: headers,
    supportPauseResume: supportPauseResume,
  );

  Future<List<DownloadModel>> getDownloadModels({
    String? id,
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

  Future<void> pause({String? id, String? tag}) =>
      KetchFlutterPlatform.instance.pause(id: id, tag: tag);

  Future<void> pauseAll() => KetchFlutterPlatform.instance.pauseAll();

  Future<void> resume({String? id, String? tag}) =>
      KetchFlutterPlatform.instance.resume();

  Future<void> resumeAll() => KetchFlutterPlatform.instance.resumeAll();

  Future<void> retry({String? id, String? tag}) =>
      KetchFlutterPlatform.instance.retry(id: id, tag: tag);

  Future<void> retryAll() => KetchFlutterPlatform.instance.retryAll();

  Future<void> setup({
    bool enableLogs = true,
    DownloadConfig? downloadConfig,
    NotificationConfig? notificationConfig,
  }) => KetchFlutterPlatform.instance.setup(
    enableLogs: enableLogs,
    downloadConfig: downloadConfig,
    notificationConfig: notificationConfig,
  );
}
