package com.keysight.pathwave.staging.pma;

import com.umeng.commonsdk.utils.UMUtils;
import com.keysight.pathwave.staging.pma.helper.MyPreferences;
import com.keysight.pathwave.staging.pma.helper.PushHelper;
import com.umeng.commonsdk.UMConfigure;

import io.flutter.app.FlutterApplication;

public class MainApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();
        UMConfigure.setLogEnabled(false);
        // PushHelper.init(getApplicationContext());
        // PushHelper.preInit(this);
        // if (MyPreferences.getInstance(this).hasAgreePrivacyAgreement()) {
        //     if (UMUtils.isMainProgress(this)) {
        //         new Thread(new Runnable() {
        //             @Override
        //             public void run() {
        //                 PushHelper.init(getApplicationContext());
        //             }
        //         }).start();
        //     } else {
        //         PushHelper.init(getApplicationContext());
        //     }
        // }
    }

}