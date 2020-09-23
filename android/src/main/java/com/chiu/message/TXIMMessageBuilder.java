package com.chiu.tencentim.message;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.imsdk.v2.V2TIMElem;
import com.tencent.imsdk.v2.V2TIMImageElem;
import com.tencent.imsdk.v2.V2TIMManager;
import com.tencent.imsdk.v2.V2TIMMessage;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

public class TXIMMessageBuilder {
    public static TXIMMessageInfo buildTextMessage(String message) {
        TXIMMessageInfo info = new TXIMMessageInfo();
        V2TIMMessage msg = V2TIMManager.getMessageManager().createTextMessage(message);
        info.setExtra(message);
        info.setMsgTime(System.currentTimeMillis());
        info.setSelf(true);
        info.setMsg(msg);
        info.setSender(V2TIMManager.getInstance().getLoginUser());
        info.setMsgType(TXIMMessageInfo.MSG_TYPE_TEXT);
        return info;
    }

    public static TXIMMessageInfo buildMessage(int type, String content) {
        switch (type) {
            case TXIMMessageInfo.MSG_TYPE_TEXT:
                return buildTextMessage(content);
            default:
                return null;
        }
    }

    public static TXIMMessageInfo buildMessageWithTIMMessage(V2TIMMessage msg) {
        if (msg == null || msg.getStatus() == V2TIMMessage.V2TIM_MSG_STATUS_HAS_DELETED) {
            return null;
        }
        TXIMMessageInfo info = new TXIMMessageInfo();
        info.setMsg(msg);
        info.setMsgId(msg.getMsgID());
        info.setMsgTime(msg.getTimestamp() * 1000);
        info.setSelf(msg.isSelf());
        if (msg.getElemType() == V2TIMMessage.V2TIM_ELEM_TYPE_TEXT) {
            info.setExtra(msg.getTextElem().getText());
        }
        if (info.isSelf()) {
            info.setSender(msg.getSender());
            info.setReceiver(msg.getUserID());
            info.setRead(msg.isPeerRead());
        } else {
            info.setSender(msg.getSender());
            info.setSenderAvatar(msg.getFaceUrl());
            info.setSenderNickName(msg.getNickName());
        }
        return info;
    }

    public static int getMessageType(int type) {
        switch (type) {
            default:
            case V2TIMMessage.V2TIM_ELEM_TYPE_NONE:
                return TXIMMessageInfo.MSG_TYPE_UNKNOW;
            case V2TIMMessage.V2TIM_ELEM_TYPE_TEXT:
                return TXIMMessageInfo.MSG_TYPE_TEXT;
            case V2TIMMessage.V2TIM_ELEM_TYPE_CUSTOM:
                return TXIMMessageInfo.MSG_TYPE_CUSTOM;
            case V2TIMMessage.V2TIM_ELEM_TYPE_IMAGE:
                return TXIMMessageInfo.MSG_TYPE_IMAGE;
            case V2TIMMessage.V2TIM_ELEM_TYPE_SOUND:
                return TXIMMessageInfo.MSG_TYPE_AUDIO;
            case V2TIMMessage.V2TIM_ELEM_TYPE_VIDEO:
                return TXIMMessageInfo.MSG_TYPE_VIDEO;
            case V2TIMMessage.V2TIM_ELEM_TYPE_FILE:
                return TXIMMessageInfo.MSG_TYPE_FILE;
            case V2TIMMessage.V2TIM_ELEM_TYPE_LOCATION:
                return TXIMMessageInfo.MSG_TYPE_LOCATION;
            case V2TIMMessage.V2TIM_ELEM_TYPE_FACE:
                return TXIMMessageInfo.MSG_TYPE_CUSTOM_FACE;
            case V2TIMMessage.V2TIM_ELEM_TYPE_GROUP_TIPS:
                return TXIMMessageInfo.MSG_TYPE_GROUP_TIPS;
        }
    }

    public static List<TXIMMessageInfo> normalizeMessageHistory(List<V2TIMMessage> messages) {
        ArrayList<TXIMMessageInfo> list = new ArrayList<TXIMMessageInfo>();
        for (int i = 0 ; i < messages.size() ; ++ i) {
            V2TIMMessage msg = messages.get(i);
            TXIMMessageInfo info = TXIMMessageBuilder.buildMessageWithTIMMessage(msg);
            list.add(info);
        }
        return list;
    }

    public static WritableArray normalizeConversationList(List<V2TIMConversation> timMessages) {
        WritableArray list = Arguments.createArray();
        for (int i = 0 ; i < timMessages.size() ; ++ i) {
            WritableMap obj = Arguments.createMap();
            V2TIMConversation conv = timMessages.get(i);
            int unreadNum = conv.getUnreadCount();
            V2TIMMessage msg = conv.getLastMessage();
            TXIMMessageInfo info = TXIMMessageBuilder.buildMessageWithTIMMessage(msg);
            String peer = conv.getGroupID() == null ? conv.getUserID() : conv.getGroupID();
            obj.putInt("unread", unreadNum);
            if (msg != null) {
                obj.putMap("message", info.toDict());
            }
            obj.putString("peer", peer);
            if (conv.getType() == 1) {
                obj.putString("type", "1");
            } else {
                obj.putString("type", "2");
            }
            obj.putString("name", conv.getShowName());
            obj.putString("faceUrl", conv.getFaceUrl());
            list.pushMap(obj);
        }
        return list;
    }
}
