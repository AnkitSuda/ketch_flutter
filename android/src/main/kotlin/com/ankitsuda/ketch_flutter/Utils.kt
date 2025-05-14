package com.ankitsuda.ketch_flutter

import com.ketch.Status

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

fun isOnlyOneNonNull(vararg values: Any?): Boolean {
    return values.count { it != null } == 1
}

fun areAllNull(vararg values: Any?): Boolean {
    return values.count { it != null } == 0
}
