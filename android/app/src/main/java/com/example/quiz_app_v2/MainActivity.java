package com.example.quiz_app_v2;

import android.content.Intent;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.quiz_app_v2/deeplink";

    @Override
    public void onNewIntent(Intent intent) {
        super.onNewIntent(intent);

        // Vérifie si l'intent est un deeplink
        if (Intent.ACTION_VIEW.equals(intent.getAction())) {
            String deeplink = intent.getDataString();

            // Envoie l'URL du deeplink à Flutter via le MethodChannel
            new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL)
                    .invokeMethod("getDeeplink", deeplink);
        }
    }
}