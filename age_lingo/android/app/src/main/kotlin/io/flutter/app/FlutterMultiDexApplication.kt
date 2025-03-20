package io.flutter.app

import io.flutter.embedding.engine.FlutterEngine
import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback
import io.flutter.plugins.GeneratedPluginRegistrant

class FlutterMultiDexApplication : Application(), PluginRegistrantCallback {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    override fun registerWith(registry: PluginRegistry) {
        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
    }
} 