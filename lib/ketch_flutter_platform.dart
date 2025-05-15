import 'package:ketch_flutter/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'ketch_flutter_mixin.dart';
import 'model/download_config.dart';
import 'model/notification_config.dart';

/// An implementation of [KetchFlutterPlatform] that uses method channels.
class KetchFlutterPlatform extends PlatformInterface
    with KetchFlutterPlatformMixin {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel(METHOD_CHANNEL_NAME);
  final eventChannel = const EventChannel(EVENT_CHANNEL_NAME);

  static final Object _token = Object();

  static KetchFlutterPlatform _instance = KetchFlutterPlatform();

  KetchFlutterPlatform() : super(token: _token);

  /// The default instance of [KetchFlutterPlatform] to use.
  ///
  /// Defaults to [KetchFlutterPlatform].
  static KetchFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KetchFlutterPlatform] when
  /// they register themselves.
  static set instance(KetchFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<dynamic> getEventStream() {
    return eventChannel.receiveBroadcastStream();
  }

  @override
  Future<void> setup({
    bool enableLogs = true,
    DownloadConfig? downloadConfig,
    NotificationConfig? notificationConfig,
  }) {
    final mDownloadConfig = downloadConfig ?? const DownloadConfig();
    final mNotificationConfig =
        notificationConfig ?? const NotificationConfig(smallIcon: 0);

    return methodChannel.invokeMethod(METHOD_SETUP, {
      "enableLogs": enableLogs,
      "downloadConfig": {
        "connectTimeOutInMs": mDownloadConfig.connectTimeOutInMs,
        "readTimeOutInMs": mDownloadConfig.readTimeOutInMs,
      },
      "notificationConfig": {
        "enabled": mNotificationConfig.enabled,
        "channelName": mNotificationConfig.channelName,
        "channelDescription": mNotificationConfig.channelDescription,
        "importance": mNotificationConfig.importance,
        "showSpeed": mNotificationConfig.showSpeed,
        "showSize": mNotificationConfig.showSize,
        "showTime": mNotificationConfig.showTime,
        "smallIcon": mNotificationConfig.smallIcon,
      },
    });
  }

  @override
  Future<int?> download({
    required String url,
    required String path,
    String? fileName,
    String tag = "",
    String metaData = "",
    Map<String, String> headers = const {},
    bool supportPauseResume = true,
  }) {
    return methodChannel.invokeMethod<int>(METHOD_DOWNLOAD, {
      "url": url,
      "path": path,
      "fileName": fileName,
      "tag": tag,
      "metaData": metaData,
      "headers": headers,
      "supportPauseResume": supportPauseResume,
    });
  }

  @override
  Future<void> cancel({int? id, String? tag}) {
    return methodChannel.invokeMethod(METHOD_CANCEL, {"id": id, "tag": tag});
  }

  @override
  Future<void> cancelAll() {
    return methodChannel.invokeMethod(METHOD_CANCEL_ALL);
  }

  @override
  Future<void> pause({int? id, String? tag}) {
    return methodChannel.invokeMethod(METHOD_PAUSE, {"id": id, "tag": tag});
  }

  @override
  Future<void> pauseAll() {
    return methodChannel.invokeMethod(METHOD_PAUSE_ALL);
  }

  @override
  Future<void> resume({int? id, String? tag}) {
    return methodChannel.invokeMethod(METHOD_RESUME, {"id": id, "tag": tag});
  }

  @override
  Future<void> resumeAll() {
    return methodChannel.invokeMethod(METHOD_RESUME_ALL);
  }

  @override
  Future<void> retry({int? id, String? tag}) {
    return methodChannel.invokeMethod(METHOD_RETRY, {"id": id, "tag": tag});
  }

  @override
  Future<void> retryAll() {
    return methodChannel.invokeMethod(METHOD_RETRY_ALL);
  }

  @override
  Future<void> clearAllDb({bool deleteFile = true}) {
    return methodChannel.invokeMethod(METHOD_CLEAR_ALL_DB, {
      "deleteFile": deleteFile,
    });
  }

  @override
  Future<void> clearDb({int? id, String? tag, bool deleteFile = true}) {
    return methodChannel.invokeMethod(METHOD_CLEAR_ALL_DB, {
      "id": id,
      "tag": tag,
      "deleteFile": deleteFile,
    });
  }

  @override
  Future<List<dynamic>?> getDownloadModels({
    int? id,
    String? tag,
    String? status,
    List<String>? ids,
    List<String>? tags,
    List<String>? statuses,
  }) {
    return methodChannel.invokeMethod<List<dynamic>>(
      METHOD_GET_DOWNLOAD_MODELS,
      {
        "id": id,
        "tag": tag,
        "status": status,
        "ids": ids,
        "tags": tags,
        "statuses": statuses,
      },
    );
  }
}
