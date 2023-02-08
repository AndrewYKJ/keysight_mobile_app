package com.keysight.pathwave.staging.pma;

import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import com.umeng.analytics.MobclickAgent;
import com.umeng.message.PushAgent;
import com.umeng.commonsdk.UMConfigure;
import com.keysight.pathwave.staging.pma.helper.MyPreferences;
import com.keysight.pathwave.staging.pma.helper.UmengHelperPlugin;
import com.keysight.pathwave.staging.pma.helper.PushConstants;
import com.keysight.pathwave.staging.pma.helper.PushHelper;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // UMConfigure.init(this, PushConstants.APP_KEY, PushConstants.CHANNEL, UMConfigure.DEVICE_TYPE_PHONE, null);
        UMConfigure.preInit(this, PushConstants.APP_KEY, PushConstants.CHANNEL);
        UMConfigure.setLogEnabled(false);
        // PushHelper.init(getApplicationContext());
        // PushHelper.preInit(getApplicationContext);
        PushAgent.getInstance(this).onAppStart();

        //设置上下文
        com.umeng.umeng_common_sdk.UmengCommonSdkPlugin.setContext(this);
    }

    @Override
    protected void onPause() {
        super.onPause();
        MobclickAgent.onPause(this);
    }

    @Override
    protected void onResume() {
        super.onResume();
        MobclickAgent.onResume(this);
    }


}

