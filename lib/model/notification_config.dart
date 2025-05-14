import 'package:equatable/equatable.dart';

import '../constants.dart';

/// Notification config used to control notification behavior for downloads
class NotificationConfig extends Equatable {
  /// Whether notification is enabled
  final bool enabled;

  /// Name of the notification channel
  final String channelName;

  /// Description of the notification channel
  final String channelDescription;

  /// Importance level of the notification channel
  final int importance;

  /// Whether to show speed in the notification
  final bool showSpeed;

  /// Whether to show size in the notification
  final bool showSize;

  /// Whether to show time in the notification
  final bool showTime;

  /// Resource ID of the small icon shown in the notification
  final int smallIcon;

  const NotificationConfig({
    this.enabled = DEFAULT_VALUE_NOTIFICATION_ENABLED,
    this.channelName = DEFAULT_VALUE_NOTIFICATION_CHANNEL_NAME,
    this.channelDescription = DEFAULT_VALUE_NOTIFICATION_CHANNEL_DESCRIPTION,
    this.importance = DEFAULT_VALUE_NOTIFICATION_CHANNEL_IMPORTANCE,
    this.showSpeed = true,
    this.showSize = true,
    this.showTime = true,
    required this.smallIcon,
  });

  @override
  List<Object?> get props => [
    enabled,
    channelName,
    channelDescription,
    importance,
    showSpeed,
    showSize,
    showTime,
    smallIcon,
  ];
}
