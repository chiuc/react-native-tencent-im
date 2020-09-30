package com.chiu.tencentim.module;

import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.widget.Toast;

import com.chiu.tencentim.TXIMManager;
import com.chiu.tencentim.constant.TXIMEventNameConstant;
import com.chiu.tencentim.listener.AdvancedMessageListener;
import com.chiu.tencentim.listener.ConversationListener;
import com.chiu.tencentim.message.TXIMMessageInfo;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.tencent.imsdk.v2.V2TIMCallback;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Nonnull;


/**
 * @author chiu
 */

public class InitializeModule extends BaseModule {

    private ReactApplicationContext context;

    public InitializeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    @Override
    public Map<String, Object> getConstants() {
        //让js那边能够使用这些常量
        // 事件名称

        Map<String, Object> eventNameDict = new HashMap<>();
        eventNameDict.put("loginStatus", TXIMEventNameConstant.USER_STATUS_CHANGE);
        eventNameDict.put("initializeStatus", TXIMEventNameConstant.INITIALIZE_STATUS);
        eventNameDict.put("userStatus", TXIMEventNameConstant.LOGIN_STATUS);
        eventNameDict.put("onNewMessage", TXIMEventNameConstant.ON_NEW_MESSAGE);
        eventNameDict.put("onConversationRefresh", TXIMEventNameConstant.ON_CONVERSATION_REFRESH);

        Map<String, Object> messageTypeDict = new HashMap<>();

        //消息类型
        messageTypeDict.put("Text", TXIMMessageInfo.MSG_TYPE_TEXT);
        messageTypeDict.put("Image", TXIMMessageInfo.MSG_TYPE_IMAGE);
        messageTypeDict.put("Sound", TXIMMessageInfo.MSG_TYPE_AUDIO);
        messageTypeDict.put("Video", TXIMMessageInfo.MSG_TYPE_VIDEO);
        messageTypeDict.put("File", TXIMMessageInfo.MSG_TYPE_FILE);
        messageTypeDict.put("Location", TXIMMessageInfo.MSG_TYPE_LOCATION);
        messageTypeDict.put("Face", TXIMMessageInfo.MSG_TYPE_CUSTOM_FACE);
        messageTypeDict.put("Custom", TXIMMessageInfo.MSG_TYPE_CUSTOM);

        Map<String, Object> dict = new HashMap<>();
        dict.put("EventName", eventNameDict);
        dict.put("MessageType", messageTypeDict);
        return dict;
    }

    @Override
    public void configListener() {
        super.configListener();
        TXIMManager.getInstance().setConversationListener(new ConversationListener(this, TXIMEventNameConstant.ON_CONVERSATION_REFRESH));
        TXIMManager.getInstance().setAdvancedMsgListener(new AdvancedMessageListener(this, TXIMEventNameConstant.ON_NEW_MESSAGE));
    }

    @Nonnull
    @Override
    public String getName() {
        return "TXIMInitializeModule";
    }

    @ReactMethod
    private void login(String account, String userSig, final Promise promise) {
        TXIMManager.getInstance().login(account, userSig, new V2TIMCallback() {
            @Override
            public void onError(int i, String s) {
                promise.reject(String.valueOf(i), s);
            }

            @Override
            public void onSuccess() {
                WritableMap map = Arguments.createMap();
                map.putInt("code", 0);
                map.putString("msg", "Login Success");
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    private void logout(final Promise promise) {
        TXIMManager.getInstance().logout(new V2TIMCallback() {
            @Override
            public void onError(int i, String s) {
                promise.reject(String.valueOf(i), s);
            }

            @Override
            public void onSuccess() {
                WritableMap map = Arguments.createMap();
                map.putInt("code", 0);
                map.putString("msg", "Logout Success");
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    private void updatePushToken(String token) {
        TXIMManager.getInstance().updatePushToken(token);
    }
}