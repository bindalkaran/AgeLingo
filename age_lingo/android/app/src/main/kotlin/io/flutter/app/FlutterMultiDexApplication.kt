package io.flutter.app

import android.app.Application
import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.view.FlutterMain

class FlutterMultiDexApplication : Application() {
    override fun attachBaseContext(base: Context) {
        super.attachBaseContext(base)
        MultiDex.install(this)
    }

    override fun onCreate() {
        super.onCreate()
        // This is required for V2 embedding
        FlutterMain.startInitialization(this)
    }
} 