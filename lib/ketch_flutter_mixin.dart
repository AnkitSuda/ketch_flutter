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

  Future<void> cancel({int? id, String? tag});

  Future<void> cancelAll();

  Future<void> pause({int? id, String? tag});

  Future<void> pauseAll();

  Future<void> resume({int? id, String? tag});

  Future<void> resumeAll();

  Future<void> retry({int? id, String? tag});

  Future<void> retryAll();

  Future<void> clearAllDb({bool deleteFile = true});

  Future<void> clearDb({int? id, String? tag, bool deleteFile = true});

  Future<List<dynamic>?> getDownloadModels({
    int? id,
    String? tag,
    String? status,
    List<String>? ids,
    List<String>? tags,
    List<String>? statuses,
  });
}
