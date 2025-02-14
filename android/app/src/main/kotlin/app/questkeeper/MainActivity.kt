package app.questkeeper

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.google.android.gms.common.GoogleApiAvailabilityLight

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.questkeeper/play_services"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isPlayServicesAvailable" -> {
                    val availability = GoogleApiAvailabilityLight.getInstance()
                    if (availability == null) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    val status = availability.isGooglePlayServicesAvailable(context)
                    result.success(status == com.google.android.gms.common.ConnectionResult.SUCCESS)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
} 