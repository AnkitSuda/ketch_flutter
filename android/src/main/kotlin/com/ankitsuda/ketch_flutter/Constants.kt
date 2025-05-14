package com.ankitsuda.ketch_flutter

// DownloadConfig
const val DEFAULT_VALUE_READ_TIMEOUT_MS = 10000L
const val DEFAULT_VALUE_CONNECT_TIMEOUT_MS = 10000L

// NotificationConfig
const val DEFAULT_VALUE_NOTIFICATION_ENABLED = false
const val DEFAULT_VALUE_NOTIFICATION_CHANNEL_NAME = "File Download"
const val DEFAULT_VALUE_NOTIFICATION_CHANNEL_DESCRIPTION = "Notify file download status"
const val DEFAULT_VALUE_NOTIFICATION_CHANNEL_IMPORTANCE = 2 // LOW

const val METHOD_CHANNEL_NAME = "ketch_flutter/method"
const val EVENT_CHANNEL_NAME = "ketch_flutter/flow"
const val METHOD_SETUP = "setup"
const val METHOD_DOWNLOAD = "download"
const val METHOD_CANCEL = "cancel"
const val METHOD_CANCEL_ALL = "cancelAll"
const val METHOD_PAUSE = "pause"
const val METHOD_PAUSE_ALL = "pauseAll"
const val METHOD_RESUME = "resume"
const val METHOD_RESUME_ALL = "resumeAll"
const val METHOD_RETRY = "retry"
const val METHOD_RETRY_ALL = "retryAll"
const val METHOD_CLEAR_ALL_DB = "clearAllDb"
const val METHOD_CLEAR_DB = "clearDb"
const val METHOD_GET_DOWNLOAD_MODELS = "getDownloadModels"