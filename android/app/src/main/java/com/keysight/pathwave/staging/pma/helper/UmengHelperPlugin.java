package com.keysight.pathwave.staging.pma.helper;

import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * UmengHelperPlugin
 */
public class UmengHelperPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String TAG = "UPushHelper";

    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        Log.e(TAG, "########## CODE IS RUNNING HERE ###########");
        mContext = flutterPluginBinding.getApplicationContext();
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "u-push-helper");
        channel.setMethodCallHandler(this);
    }

    public static void registerWith(Registrar registrar) {
        MethodChannel channel = new MethodChannel(registrar.messenger(), "u-push-helper");
        UmengHelperPlugin plugin = new UmengHelperPlugin();
        plugin.mContext = registrar.context();
        plugin.channel = channel;
        channel.setMethodCallHandler(plugin);
    }

    private Context mContext = null;

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        try {
            Log.e(TAG, "########## CODE IS RUNNING HERE ###########");
            if ("agree".equals(call.method)) {
                PushHelper.init(mContext);
                MyPreferences.getInstance(mContext).setAgreePrivacyAgreement(true);
                return;
            }
            result.notImplemented();
        } catch (Exception e) {
            Log.e(TAG, "Exception:" + e.getMessage());
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

}
