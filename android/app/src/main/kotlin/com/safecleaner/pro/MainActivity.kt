package com.safecleaner.pro

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.content.pm.ApplicationInfo
import android.app.ActivityManager
import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.os.Environment
import android.os.StatFs
import android.os.Build
import android.provider.Settings
import android.util.Log
import java.io.BufferedReader
import java.io.InputStreamReader
import java.io.File

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.safecleaner.pro/native"
    private val TAG = "MainActivityNative"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "checkShizuku" -> result.success(checkShizukuAvailable())
                    "getInstalledApps" -> result.success(getInstalledApplications())
                    "getStorageInfo" -> result.success(getStorageInfo())
                    "getMemoryInfo" -> result.success(getMemoryInfo())
                    "getCpuUsage" -> result.success(getCpuUsage())
                    "checkUsageStatsPermission" -> result.success(checkUsageStatsPermission())
                    "openUsageStatsSettings" -> {
                        openUsageStatsSettings()
                        result.success(true)
                    }
                    "executeShizukuCommand" -> {
                        val command = call.argument<String>("command")
                        if (command != null) {
                            result.success(executeShellCommand(command))
                        } else {
                            result.error("INVALID_ARGS", "Command null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                Log.e(TAG, "MethodChannel handler error", e)
                result.error("NATIVE_ERROR", e.message ?: "error", null)
            }
        }
    }

    private fun checkShizukuAvailable(): Boolean {
        return try {
            packageManager.getPackageInfo("moe.shizuku.privileged.api", 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun checkUsageStatsPermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), packageName)
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun openUsageStatsSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        startActivity(intent)
    }

    private fun getStorageInfo(): Map<String, Long> {
        val path = Environment.getDataDirectory()
        val stat = StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val totalBlocks = stat.blockCountLong
        val availableBlocks = stat.availableBlocksLong
        
        return mapOf(
            "total" to totalBlocks * blockSize,
            "available" to availableBlocks * blockSize,
            "used" to (totalBlocks - availableBlocks) * blockSize
        )
    }

    private fun getMemoryInfo(): Map<String, Long> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        
        return mapOf(
            "total" to memoryInfo.totalMem,
            "available" to memoryInfo.availMem,
            "used" to (memoryInfo.totalMem - memoryInfo.availMem),
            "threshold" to memoryInfo.threshold,
            "lowMemory" to if (memoryInfo.lowMemory) 1L else 0L
        )
    }

    private fun getCpuUsage(): Double {
        return try {
            val reader = BufferedReader(InputStreamReader(Runtime.getRuntime().exec("top -n 1").inputStream))
            var line: String?
            var cpu = 0.0
            while (reader.readLine().also { line = it } != null) {
                if (line!!.contains("CPU")) {
                    val match = Regex("(\\d+)%").find(line!!)
                    if (match != null) {
                        cpu = match.groupValues[1].toDouble()
                        break
                    }
                }
            }
            cpu
        } catch (e: Exception) {
            0.0
        }
    }

    private fun getInstalledApplications(): List<Map<String, Any>> {
        val pm = packageManager
        val apps = pm.getInstalledApplications(PackageManager.GET_META_DATA)
        return apps.map { app ->
            mapOf(
                "packageName" to app.packageName,
                "appName" to pm.getApplicationLabel(app).toString(),
                "isSystemApp" to ((app.flags and ApplicationInfo.FLAG_SYSTEM) != 0),
                "enabled" to app.enabled,
                "uid" to app.uid,
                "sourceDir" to app.sourceDir
            )
        }
    }

    private fun executeShellCommand(command: String): String {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("sh", "-c", command))
            val output = process.inputStream.bufferedReader().use { it.readText() }
            process.waitFor()
            output
        } catch (e: Exception) {
            "Error: ${e.message}"
        }
    }
}
