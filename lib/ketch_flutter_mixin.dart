import 'model/download_config.dart';
import 'model/notification_config.dart';

mixin KetchFlutterPlatformMixin {
  Future<void> setup({
    bool enableLogs = true,
    DownloadConfig? downloadConfig,
    NotificationConfig? notificationConfig,
  });

  Future<int?> download({
    required String url,
    required String path,
    String? fileName,
    String tag = "",
    String metaData = "",
    Map<String, String> headers = const {},
    bool supportPauseResume = true,
  });

  Future<void> cancel({String? id, String? tag});

  Future<void> cancelAll();

  Future<void> pause({String? id, String? tag});

  Future<void> pauseAll();

  Future<void> resume({String? id, String? tag});

  Future<void> resumeAll();

  Future<void> retry({String? id, String? tag});

  Future<void> retryAll();

  Future<void> clearAllDb({bool deleteFile = true});

  Future<void> clearDb({String? id, String? tag, bool deleteFile = true});

  Future<List<dynamic>?> getDownloadModels({
    String? id,
    String? tag,
    String? status,
    List<String>? ids,
    List<String>? tags,
    List<String>? statuses,
  });
}
