package com.chiu.tencentim.module;

import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.widget.Toast;

import com.chiu.tencentim.TXIMManager;
import com.chiu.tencentim.constant.TXIMEventNameConstant;
import com.chiu.tencentim.message.TXIMMessageBuilder;
import com.chiu.tencentim.message.TXIMMessageInfo;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.tencent.imsdk.v2.V2TIMConversationResult;
import com.tencent.imsdk.v2.V2TIMMessage;
import com.tencent.imsdk.v2.V2TIMSendCallback;
import com.tencent.imsdk.v2.V2TIMValueCallback;


import org.json.JSONException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Nonnull;

/**
 * @author chiu
 */

public class MessageModule extends BaseModule {

    private Context context;

    public MessageModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.context = reactContext;
    }

    @Override
    public Map<String, Object> getConstants() {
        //让js那边能够使用这些常量
        // 事件名称
        Map<String, Object> eventNameDict = new HashMap<>();
        eventNameDict.put("onNewMessage", TXIMEventNameConstant.ON_NEW_MESSAGE);
        eventNameDict.put("onConversationRefresh", TXIMEventNameConstant.ON_CONVERSATION_REFRESH);


        Map<String, Object> dict = new HashMap<>();
        dict.put("EventName", eventNameDict);
        return dict;
    }

    @Nonnull
    @Override
    public String getName() {
        return "TXIMMessageModule";
    }

    @ReactMethod
    private void getConversationList(final Promise promise) {
        TXIMManager.getInstance().getConversationList(new V2TIMValueCallback<V2TIMConversationResult>() {
            @Override
            public void onError(int i, String s) {
                promise.reject(String.valueOf(i), s);
            }

            @Override
            public void onSuccess(V2TIMConversationResult v2TIMConversationResult) {
                WritableMap map = Arguments.createMap();
                map.putInt("code", 0);
                map.putString("msg", "getConversationList Success");
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    private void getConversation(int type, String receiver, final Promise promise) {
        TXIMManager.getInstance().getConversation(type, receiver, new V2TIMValueCallback<List<V2TIMMessage>>() {
            @Override
            public void onError(int i, String s) {
                promise.reject(String.valueOf(i), s);
            }

            @Override
            public void onSuccess(List<V2TIMMessage> msgs) {
                List<TXIMMessageInfo> infos = TXIMMessageBuilder.normalizeMessageHistory(msgs);
                WritableArray data = Arguments.createArray();
                for (int i = 0 ; i < infos.size() ; ++ i) {
                    TXIMMessageInfo info = infos.get(i);
                    data.pushMap(info.toDict());
                }
                WritableMap map = Arguments.createMap();
                map.putInt("code", 0);
                map.putString("msg", "sendMessage Success");
                map.putArray("data", data);
                promise.resolve(map);
            }
        });
    }

    @ReactMethod
    private void sendMessage(String content, Boolean isGroup, final Promise promise) {
        try {
            TXIMManager.getInstance().sendMessage(1, content, isGroup, new V2TIMSendCallback<V2TIMMessage>() {
                @Override
                public void onProgress(int i) {

                }

                @Override
                public void onError(int i, String s) {
                    promise.reject(String.valueOf(i), s);
                }

                @Override
                public void onSuccess(V2TIMMessage msg) {
                    TXIMMessageInfo info = TXIMMessageBuilder.buildMessageWithTIMMessage(msg);
                    WritableMap map = Arguments.createMap();
                    map.putInt("code", 0);
                    map.putString("msg", "sendMessage Success");
                    map.putMap("data", info.toDict());
                    promise.resolve(map);
                }
            });
        }catch (JSONException e) {
            promise.reject(String.valueOf(-1), e.getMessage());
        }
    }

}