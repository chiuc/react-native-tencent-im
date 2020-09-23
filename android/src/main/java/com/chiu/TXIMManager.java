package com.chiu.tencentim;

import android.content.Context;

import com.chiu.tencentim.message.TXIMMessageBuilder;
import com.chiu.tencentim.message.TXIMMessageInfo;
import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.tencent.imsdk.v2.V2TIMAdvancedMsgListener;
import com.tencent.imsdk.v2.V2TIMCallback;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.imsdk.v2.V2TIMConversationListener;
import com.tencent.imsdk.v2.V2TIMConversationResult;
import com.tencent.imsdk.v2.V2TIMManager;
import com.tencent.imsdk.v2.V2TIMMessage;
import com.tencent.imsdk.v2.V2TIMMessageManager;
import com.tencent.imsdk.v2.V2TIMOfflinePushInfo;
import com.tencent.imsdk.v2.V2TIMSDKConfig;
import com.tencent.imsdk.v2.V2TIMSDKListener;
import com.tencent.imsdk.v2.V2TIMSendCallback;
import com.tencent.imsdk.v2.V2TIMSignalingListener;
import com.tencent.imsdk.v2.V2TIMSimpleMsgListener;
import com.tencent.imsdk.v2.V2TIMUserFullInfo;
import com.tencent.imsdk.v2.V2TIMValueCallback;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class TXIMManager {

    public static TXIMManager instance;

    private static Context appContext;

    private static Boolean isInit;

    private static String currentReceiver;

    private static V2TIMConversation conversation;

    private static String businessID;

    private static String sdkAppId;

    private List<V2TIMConversation> convLists;

    public static TXIMManager getInstance(){
        if(instance == null){
            instance = new TXIMManager();
        }
        return instance;
    }

    public void initWithAppId(Context context, String sdkAppID) {
        appContext = context;
        V2TIMSDKConfig config = new V2TIMSDKConfig();
        config.setLogLevel(V2TIMSDKConfig.V2TIM_LOG_INFO);

        V2TIMManager.getInstance().initSDK(context, Integer.parseInt(sdkAppID), config, new V2TIMSDKListener() {
            @Override
            public void onConnecting() {
                super.onConnecting();
            }

            @Override
            public void onConnectSuccess() {
                super.onConnectSuccess();
            }

            @Override
            public void onConnectFailed(int code, String error) {
                super.onConnectFailed(code, error);
            }
        });
    }

    public void configBusinessID(String token) {
        businessID = token;
    }

    public void setConversationListener(V2TIMConversationListener listener) {
        V2TIMManager.getConversationManager().setConversationListener(listener);
    }

    public void setSimpleMessageListener(V2TIMSimpleMsgListener listener) {
        V2TIMManager.getInstance().addSimpleMsgListener(listener);
    }

    public void setAdvancedMsgListener(V2TIMAdvancedMsgListener listener) {
        V2TIMManager.getMessageManager().addAdvancedMsgListener(listener);
    }

    public void setSignalingListener(V2TIMSignalingListener listener) {
        V2TIMManager.getSignalingManager().addSignalingListener(listener);
    }

    public void login(final String identify, final String userSig, final V2TIMCallback callback) {
        if (V2TIMManager.getInstance().getLoginStatus() == V2TIMManager.V2TIM_STATUS_LOGINED) {
            V2TIMManager.getInstance().logout(new V2TIMCallback() {
                @Override
                public void onError(int i, String s) {
                    callback.onError(i, s);
                }

                @Override
                public void onSuccess() {
                    V2TIMManager.getInstance().login(identify, userSig, new V2TIMCallback() {
                        @Override
                        public void onError(int i, String s) {
                            callback.onError(i, s);
                        }

                        @Override
                        public void onSuccess() {
                            callback.onSuccess();
                        }
                    });
                }
            });
        } else {
            V2TIMManager.getInstance().login(identify, userSig, new V2TIMCallback() {
                @Override
                public void onError(int i, String s) {
                    callback.onError(i, s);
                }

                @Override
                public void onSuccess() {
                    callback.onSuccess();
                }
            });
        }
    }

    public void logout(V2TIMCallback callback) {
        V2TIMManager.getInstance().logout(callback);
    }

    public void getConversation(int type, String receiver, final V2TIMValueCallback<List<V2TIMMessage>> callback) {
        if (V2TIMManager.getInstance().getLoginStatus() == V2TIMManager.V2TIM_STATUS_LOGINED) {
            currentReceiver = receiver;
            if (type == 1) {
                V2TIMManager.getMessageManager().getC2CHistoryMessageList(receiver, 100, null, new V2TIMValueCallback<List<V2TIMMessage>>() {
                    @Override
                    public void onError(int i, String s) {
                        callback.onError(i, s);
                    }

                    @Override
                    public void onSuccess(List<V2TIMMessage> v2TIMMessages) {
                        callback.onSuccess(v2TIMMessages);
                    }
                });
            } else {
                V2TIMManager.getMessageManager().getGroupHistoryMessageList(receiver, 100, null, new V2TIMValueCallback<List<V2TIMMessage>>() {
                    @Override
                    public void onError(int i, String s) {
                        callback.onError(i, s);
                    }

                    @Override
                    public void onSuccess(List<V2TIMMessage> v2TIMMessages) {
                        callback.onSuccess(v2TIMMessages);
                    }
                });
            }
        } else {
            callback.onError(-1, "Please login");
        }
    }

    public void setMessageRead(V2TIMMessage message, final V2TIMCallback listener) {
        if (conversation != null && conversation.getUserID().equals(message.getUserID())) {
            V2TIMManager.getMessageManager().markC2CMessageAsRead(message.getUserID(), new V2TIMCallback() {
                @Override
                public void onError(int i, String s) {
                    listener.onError(i, s);
                }

                @Override
                public void onSuccess() {
                    listener.onSuccess();
                }
            });
        }
    }

    public void sendMessage(int type, String content, boolean isGroup, final V2TIMSendCallback<V2TIMMessage> callback) throws JSONException {
        if (V2TIMManager.getInstance().getLoginStatus() != V2TIMManager.V2TIM_STATUS_LOGINED) {
            return;
        }
        TXIMMessageInfo msg = TXIMMessageBuilder.buildMessage(type, content);
        msg.setSender(V2TIMManager.getInstance().getLoginUser());
        msg.setReceiver(currentReceiver);
        msg.setSelf(true);

        WritableMap map = Arguments.createMap();
        map.putString("target", currentReceiver);

        V2TIMOfflinePushInfo info = new V2TIMOfflinePushInfo();
        JSONObject json = new JSONObject(map.toString());

        V2TIMManager.getMessageManager().sendMessage(msg.getMsg(), !isGroup ? currentReceiver:null, isGroup ? currentReceiver: null, V2TIMMessage.V2TIM_PRIORITY_DEFAULT, false,  info, new V2TIMSendCallback<V2TIMMessage>() {
            @Override
            public void onProgress(int i) {

            }

            @Override
            public void onError(int i, String s) {
                callback.onError(i, s);
            }

            @Override
            public void onSuccess(V2TIMMessage v2TIMMessage) {
                callback.onSuccess(v2TIMMessage);
            }
        });
    }

    public void destroyConversation(final V2TIMCallback callback) {
        if (conversation != null && V2TIMManager.getInstance().getLoginStatus() == V2TIMManager.V2TIM_STATUS_LOGINED) {
            V2TIMManager.getConversationManager().deleteConversation(conversation.getConversationID(), new V2TIMCallback() {
                @Override
                public void onError(int i, String s) {
                    callback.onError(i, s);
                }

                @Override
                public void onSuccess() {
                    callback.onSuccess();
                }
            });
        }
    }

    public int getUnReadCount() {
        return 0;
    }

    public List<V2TIMConversation> getConversation() {
        return convLists;
    }

    public void getConversationList(final V2TIMValueCallback<V2TIMConversationResult> callback) {
        if (V2TIMManager.getInstance().getLoginStatus() == V2TIMManager.V2TIM_STATUS_LOGINED) {
            V2TIMManager.getConversationManager().getConversationList(0, 50, new V2TIMValueCallback<V2TIMConversationResult>() {
                @Override
                public void onError(int i, String s) {
                    callback.onError(i, s);
                }

                @Override
                public void onSuccess(V2TIMConversationResult v2TIMConversationResult) {
                    updateConversationWithList(v2TIMConversationResult.getConversationList());
                    callback.onSuccess(v2TIMConversationResult);
                }
            });
        }
    }

    public void updateConversationWithList(List<V2TIMConversation> convList) {
        for (int i = 0 ; i < convList.size() ; ++ i) {
            V2TIMConversation conv = convList.get(i);
            boolean isExit = false;
            for (int j = 0 ; j < convLists.size() ; ++ j) {
                V2TIMConversation _Conv = convLists.get(j);
                if ( getConversationIDFromConversation(_Conv).equals(getConversationIDFromConversation(conv))) {
                    convLists.set(j, conv);
                    isExit = true;
                    break;
                }
            }
            if (!isExit) {
                convLists.add(conv);
            }
        }
        Collections.sort(convLists, new Comparator<V2TIMConversation>() {
            @Override
            public int compare(V2TIMConversation obj1, V2TIMConversation obj2) {
                return (int)obj2.getLastMessage().getTimestamp() - (int)obj1.getLastMessage().getTimestamp();
            }
        });
    }

    private String getConversationIDFromConversation(V2TIMConversation conv) {
            return conv.getGroupID() != null? conv.getGroupID() : conv.getUserID();
    }
}
