package com.keysight.pathwave.staging.pma.helper;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import com.umeng.commonsdk.UMConfigure;
import com.umeng.commonsdk.utils.UMUtils;
import com.umeng.message.PushAgent;
import com.umeng.message.api.UPushRegisterCallback;

/**
 * PushSDK集成帮助类
 */
public class PushHelper {

    private static final String TAG = "PushHelper";

    /**
     * 预初始化。
     * 场景：用户未同意隐私政策协议授权时
     *
     * @param context 应用上下文
     */
    public static void preInit(Context context) {
        PushAgent.setup(context, PushConstants.APP_KEY, PushConstants.MESSAGE_SECRET);
        UMConfigure.preInit(context, PushConstants.APP_KEY, PushConstants.CHANNEL);
    }

    /**
     * 初始化。
     * 场景：用户已同意隐私政策协议授权时
     *
     * @param context 应用上下文
     */
    public static void init(Context context) {
        // 在此处调用基础组件包提供的初始化函数 相应信息可在应用管理 -> 应用信息 中找到 http://message.umeng.com/list/apps
        // 参数一：当前上下文context；
        // 参数二：应用申请的Appkey；
        // 参数三：渠道名称；
        // 参数四：设备类型，必须参数，传参数为UMConfigure.DEVICE_TYPE_PHONE则表示手机；传参数为UMConfigure.DEVICE_TYPE_BOX则表示盒子；默认为手机；
        // 参数五：Push推送业务的secret 填充Umeng Message Secret对应信息
        UMConfigure.init(
                context,
                PushConstants.APP_KEY,
                PushConstants.CHANNEL,
                UMConfigure.DEVICE_TYPE_PHONE,
                PushConstants.MESSAGE_SECRET
        );

        //获取消息推送实例
        PushAgent pushAgent = PushAgent.getInstance(context);
        pushAgent.setDisplayNotificationNumber(0);
        //注册推送服务，每次调用register方法都会回调该接口
        pushAgent.register(new UPushRegisterCallback() {

            @Override
            public void onSuccess(String deviceToken) {
                //注册成功会返回deviceToken deviceToken是推送消息的唯一标志
                Log.i(TAG, "注册成功: deviceToken：--> " + deviceToken);
            }

            @Override
            public void onFailure(String errCode, String errDesc) {
                Log.e(TAG, "注册失败:" + "errCode:" + errCode + ", errDesc:" + errDesc);
            }
        });
    }
}
