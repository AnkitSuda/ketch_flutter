// DownloadConfig
const int DEFAULT_VALUE_READ_TIMEOUT_MS = 10000;
const int DEFAULT_VALUE_CONNECT_TIMEOUT_MS = 10000;

// NotificationConfig
const bool DEFAULT_VALUE_NOTIFICATION_ENABLED = false;
const String DEFAULT_VALUE_NOTIFICATION_CHANNEL_NAME = "File Download";
const String DEFAULT_VALUE_NOTIFICATION_CHANNEL_DESCRIPTION =
    "Notify file download status";
const int DEFAULT_VALUE_NOTIFICATION_CHANNEL_IMPORTANCE = 2; // LOW

const String METHOD_CHANNEL_NAME = "ketch_flutter/method";
const String EVENT_CHANNEL_NAME = "ketch_flutter/flow";
const String METHOD_SETUP = "setup";
const String METHOD_DOWNLOAD = "download";
const String METHOD_CANCEL = "cancel";
const String METHOD_CANCEL_ALL = "cancelAll";
const String METHOD_PAUSE = "pause";
const String METHOD_PAUSE_ALL = "pauseAll";
const String METHOD_RESUME = "resume";
const String METHOD_RESUME_ALL = "resumeAll";
const String METHOD_RETRY = "retry";
const String METHOD_RETRY_ALL = "retryAll";
const String METHOD_CLEAR_ALL_DB = "clearAllDb";
const String METHOD_CLEAR_DB = "clearDb";
const String METHOD_GET_DOWNLOAD_MODELS = "getDownloadModels";
