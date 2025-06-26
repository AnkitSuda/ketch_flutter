package com.ankitsuda.ketch_flutter

import android.content.Context
import android.content.res.Resources
import com.ketch.Status
import com.ketch.DownloadModel

fun statusFromString(status: String): Status {
    return when (status) {
        "QUEUED" -> Status.QUEUED
        "STARTED" -> Status.STARTED
        "PROGRESS" -> Status.PROGRESS
        "SUCCESS" -> Status.SUCCESS
        "CANCELLED" -> Status.CANCELLED
        "FAILED" -> Status.FAILED
        "PAUSED" -> Status.PAUSED
        else -> Status.DEFAULT
    }
}

fun statusToString(status: Status): String {
    return when (status) {
        Status.QUEUED -> "QUEUED"
        Status.STARTED -> "STARTED"
        Status.PROGRESS -> "PROGRESS"
        Status.SUCCESS -> "SUCCESS"
        Status.CANCELLED -> "CANCELLED"
        Status.FAILED -> "FAILED"
        Status.PAUSED -> "PAUSED"
        else -> "DEFAULT"
    }
}

fun isOnlyOneNonNull(vararg values: Any?): Boolean {
    return values.count { it != null } == 1
}

fun areAllNull(vararg values: Any?): Boolean {
    return values.count { it != null } == 0
}

fun DownloadModel.toMap(): Map<String, Any> {
    return mapOf(
        "url" to url,
        "path" to path,
        "fileName" to fileName,
        "tag" to tag,
        "id" to id,
        "headers" to headers,
        "timeQueued" to timeQueued,
        "status" to statusToString(status),
        "total" to total,
        "progress" to progress,
        "speedInBytePerMs" to speedInBytePerMs,
        "lastModified" to lastModified,
        "eTag" to eTag,
        "metaData" to metaData,
        "failureReason" to failureReason,
    )
}

fun Context.resIdByName(resIdName: String?, resType: String): Int {
    resIdName?.let {
        return resources.getIdentifier(it, resType, packageName)
    }
    throw Resources.NotFoundException()
}