package com.ankitsuda.ketch_flutter

import android.content.Context
import android.util.Log
import com.ketch.DownloadConfig
import com.ketch.Ketch
import com.ketch.NotificationConfig
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.flowOn
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** KetchFlutterPlugin */
class KetchFlutterPlugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null

    private val scope = CoroutineScope(Dispatchers.Main + SupervisorJob())
    private var ketch: Ketch? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        context = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, METHOD_CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, EVENT_CHANNEL_NAME)
        eventChannel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_SETUP -> handleSetup(call, result)

            METHOD_DOWNLOAD -> handleDownload(call, result)

            METHOD_CANCEL -> handleCancel(call, result)

            METHOD_CANCEL_ALL -> handleCancelAll(call, result)

            METHOD_PAUSE -> handlePause(call, result)

            METHOD_PAUSE_ALL -> handlePauseAll(call, result)

            METHOD_RESUME -> handleResume(call, result)

            METHOD_RESUME_ALL -> handleResumeAll(call, result)

            METHOD_RETRY -> handleRetry(call, result)

            METHOD_RETRY_ALL -> handleRetryAll(call, result)

            METHOD_CLEAR_ALL_DB -> handleClearAllDb(call, result)

            METHOD_CLEAR_DB -> handleClearDb(call, result)

            METHOD_GET_DOWNLOAD_MODELS -> scope.launch {
                handleGetDownloadModels(call, result)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        scope.cancel()
        channel.setMethodCallHandler(null)
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    private fun handleSetup(call: MethodCall, result: Result) {
        if (ketch != null) {
            return
        }

        val downloadConfigMap =
            call.argument<Map<String, Any>>("downloadConfigConnectTimeOutInMs") ?: mapOf()

        val downloadConfig = DownloadConfig(
            connectTimeOutInMs = (downloadConfigMap["connectTimeOutInMs"] as Long?)
                ?: DEFAULT_VALUE_CONNECT_TIMEOUT_MS,
            readTimeOutInMs = (downloadConfigMap["readTimeOutInMs"] as Long?)
                ?: DEFAULT_VALUE_READ_TIMEOUT_MS,
        )

        val notificationConfigMap =
            call.argument<Map<String, Any>>("notificationConfig") ?: mapOf()


        val smallIcon = notificationConfigMap["smallIcon"] as Int?

        if (smallIcon == null) {
            result.error("INVALID_ARGUMENTS", "notificationConfigSmallIcon is required", null)
            return
        }

        val notificationConfig = NotificationConfig(
            enabled = (notificationConfigMap["enabled"] as Boolean?)
                ?: DEFAULT_VALUE_NOTIFICATION_ENABLED,
            channelName = (notificationConfigMap["channelName"] as String?)
                ?: DEFAULT_VALUE_NOTIFICATION_CHANNEL_NAME,
            channelDescription = (notificationConfigMap["channelDescription"] as String?)
                ?: DEFAULT_VALUE_NOTIFICATION_CHANNEL_DESCRIPTION,
            importance = (notificationConfigMap["importance"] as Int?)
                ?: DEFAULT_VALUE_NOTIFICATION_CHANNEL_IMPORTANCE,
            showSpeed = (notificationConfigMap["show"] as Boolean?) ?: true,
            showSize = (notificationConfigMap["show"] as Boolean?) ?: true,
            showTime = (notificationConfigMap["show"] as Boolean?) ?: true,
            smallIcon = smallIcon,
        )

        ketch = Ketch.builder()
            .setDownloadConfig(downloadConfig)
            .enableLogs(call.argument<Boolean>("enableLogs") ?: false)
//            .setNotificationConfig(notificationConfig)
            .build(context)

        observeDownloads()
    }

    private fun observeDownloads() {
        scope.launch {
            ketch?.observeDownloads()
                ?.flowOn(Dispatchers.IO)
                ?.collect { items ->
                    val mapList = items.map {
                        it.toMap()
                    }

                    Log.d("DADAS", (eventSink == null).toString())
                    eventSink?.success(mapList)
                }
        }
    }

    private fun handleDownload(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val url = call.argument<String>("url")
        val path = call.argument<String>("path")
        val fileName = call.argument<String>("fileName")
        val shouldGetFileNameFromUrl = call.argument<Boolean>("shouldGetFileNameFromUrl") == true
        val tag = call.argument<String>("tag")
        val metaData = call.argument<String>("metaData")
        val headers = call.argument<Map<String, String>>("headers")
        val supportPauseResume = call.argument<Boolean>("supportPauseResume") == true

        if (url == null || path == null || fileName == null) {
            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
            return
        }

        val headersHashMap = HashMap(headers ?: emptyMap())

        val id = if (shouldGetFileNameFromUrl) {
            ketch?.download(
                url = url,
                path = path,
                tag = tag ?: "",
                metaData = metaData ?: "",
                headers = headersHashMap,
                supportPauseResume = supportPauseResume,
            )
        } else {
            ketch?.download(
                url = url,
                path = path,
                fileName = fileName,
                tag = tag ?: "",
                metaData = metaData ?: "",
                headers = headersHashMap,
                supportPauseResume = supportPauseResume,
            )
        }

        result.success(id)
    }

    private fun handleCancel(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")

        if (id == null && tag == null) {
            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
            return
        }

        if (id != null && tag != null) {
            result.error("INVALID_ARGUMENTS", "Either provide id or tag not both", null)
            return
        }

        if (id != null) {
            ketch?.cancel(id = id)
        }

        if (tag != null) {
            ketch?.cancel(tag = tag)
        }

        result.success(null)
    }

    private fun handleCancelAll(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        ketch?.cancelAll()
        result.success(null)
    }

    private fun handlePause(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")

        if (id == null && tag == null) {
            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
            return
        }

        if (id != null && tag != null) {
            result.error("INVALID_ARGUMENTS", "Either provide id or tag not both", null)
            return
        }

        if (id != null) {
            ketch?.pause(id = id)
        }

        if (tag != null) {
            ketch?.pause(tag = tag)
        }

        result.success(null)
    }

    private fun handlePauseAll(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        ketch?.pauseAll()
        result.success(null)
    }

    private fun handleResume(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")

        if (id == null && tag == null) {
            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
            return
        }

        if (id != null && tag != null) {
            result.error("INVALID_ARGUMENTS", "Either provide id or tag not both", null)
            return
        }

        if (id != null) {
            ketch?.resume(id = id)
        }

        if (tag != null) {
            ketch?.resume(tag = tag)
        }

        result.success(null)
    }

    private fun handleResumeAll(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        ketch?.resumeAll()
        result.success(null)
    }

    private fun handleRetry(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")

        if (id == null && tag == null) {
            result.error("INVALID_ARGUMENTS", "Invalid arguments", null)
            return
        }

        if (id != null && tag != null) {
            result.error("INVALID_ARGUMENTS", "Either provide id or tag not both", null)
            return
        }

        if (id != null) {
            ketch?.retry(id = id)
        }

        if (tag != null) {
            ketch?.retry(tag = tag)
        }

        result.success(null)
    }

    private fun handleRetryAll(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        ketch?.retryAll()
        result.success(null)
    }

    private fun handleClearAllDb(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val deleteFile = call.argument<Boolean>("deleteFile") == true

        ketch?.clearAllDb(deleteFile = deleteFile)
        result.success(null)
    }

    private fun handleClearDb(call: MethodCall, result: Result) {
        if (ketch == null) {
            result.errorKetchNull()
            return
        }

        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")
        val timeInMillis = call.argument<Long>("timeInMillis")
        val deleteFile = call.argument<Boolean>("deleteFile") == true

        if (!isOnlyOneNonNull(id, tag, timeInMillis)) {
            result.error(
                "INVALID_ARGUMENTS",
                "Provide only one of these: id, tag, timeInMillis",
                null
            )
            return
        }

        if (timeInMillis != null) {
            ketch?.clearDb(timeInMillis = timeInMillis, deleteFile = deleteFile)
        }

        if (id != null) {
            ketch?.clearDb(id = id, deleteFile = deleteFile)
        }

        if (tag != null) {
            ketch?.clearDb(tag = tag, deleteFile = deleteFile)
        }

        result.success(null)
    }

    private suspend fun handleGetDownloadModels(call: MethodCall, result: Result) {
        val id = call.argument<Int>("id")
        val tag = call.argument<String>("tag")
        val status = call.argument<String>("status")
        val ids = call.argument<List<Int>>("ids")
        val tags = call.argument<List<String>>("tags")
        val statuses = call.argument<List<String>>("statuses")

        if (!areAllNull(id, tag, status, statuses, ids, tags) && !isOnlyOneNonNull(
                id,
                tag,
                status,
                statuses,
                ids,
                tags
            )
        ) {
            result.error(
                "INVALID_ARGUMENTS",
                "Provide only one of these: id, tag, status, ids, tags, statuses",
                null
            )
            return
        }

        val item = if (id != null) {
            ketch?.getDownloadModelById(id = id);
        } else {
            null
        }

        val items = if (tag != null) {
            ketch?.getDownloadModelByTag(tag = tag);
        } else if (status != null) {
            ketch?.getDownloadModelByStatus(status = statusFromString(status));
        } else if (ids != null) {
            ketch?.getDownloadModelByIds(ids = ids);
        } else if (tags != null) {
            ketch?.getDownloadModelByTags(tags = tags);
        } else if (statuses != null) {
            ketch?.getDownloadModelByStatuses(statuses = statuses.map(::statusFromString));
        } else {
            ketch?.getAllDownloads()
        }

        if (item != null) {
            result.success(listOf(item.toMap()))
        } else if (items != null) {
            result.success(items.map { it?.toMap() })
        } else {
            result.error("NOT_FOUND", "Items not found", null)
        }
    }

}

fun Result.errorKetchNull() {
    error("NOT_INITIALIZED", "Call setup before using", null)
}