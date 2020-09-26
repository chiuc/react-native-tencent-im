package com.chiu.tencentim.message;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.WritableMap;
import com.tencent.imsdk.v2.V2TIMMessage;

import java.util.UUID;

public class TXIMMessageInfo {
    /**
     * 未知消息
     */
    public static final int MSG_TYPE_UNKNOW = 0;
    /**
     * 文本类型消息
     */
    public static final int MSG_TYPE_TEXT = 1;
    /**
     * 自定义消息
     */
    public static final int MSG_TYPE_CUSTOM = 2;
    /**
     * 图片类型消息
     */
    public static final int MSG_TYPE_IMAGE = 3;
    /**
     * 语音类型消息
     */
    public static final int MSG_TYPE_AUDIO = 4;
    /**
     * 视频类型消息
     */
    public static final int MSG_TYPE_VIDEO = 5;
    /**
     * 文件类型消息
     */
    public static final int MSG_TYPE_FILE = 6;
    /**
     * 位置类型消息
     */
    public static final int MSG_TYPE_LOCATION = 7;

    /**
     * 表情消息
     */
    public static final int MSG_TYPE_CUSTOM_FACE = 8;

    /**
     * 群 Tips 消息
     */
    public static final int MSG_TYPE_GROUP_TIPS = 9;


    /**
     * 消息正常状态
     */
    public static final int MSG_STATUS_NORMAL = 0;
    /**
     * 消息发送中状态
     */
    public static final int MSG_STATUS_SENDING = 1;
    /**
     * 消息发送成功状态
     */
    public static final int MSG_STATUS_SEND_SUCCESS = 2;
    /**
     * 消息发送失败状态
     */
    public static final int MSG_STATUS_SEND_FAIL = 3;
    /**
     * 消息内容下载中状态
     */
    public static final int MSG_STATUS_DOWNLOADING = 4;
    /**
     * 消息内容未下载状态
     */
    public static final int MSG_STATUS_UN_DOWNLOAD = 5;
    /**
     * 消息内容已下载状态
     */
    public static final int MSG_STATUS_DOWNLOADED = 6;

    private V2TIMMessage msg;
    private String msgId = UUID.randomUUID().toString();
    private int msgType = MSG_TYPE_UNKNOW;
    private long msgTime;
    private boolean read;
    private int status = MSG_STATUS_NORMAL;
    private boolean self;
    private String sender;
    private String senderAvatar;
    private String senderNickName;
    private String receiver;
    private String extra;
    private String desc;

    public V2TIMMessage getMsg() {
        return msg;
    }

    public void setMsg(V2TIMMessage msg) {
        this.msg = msg;
    }

    public String getMsgId() {
        return msgId;
    }

    public void setMsgId(String msgId) {
        this.msgId = msgId;
    }

    public int getMsgType() {
        return msgType;
    }

    public void setMsgType(int msgType) {
        this.msgType = msgType;
    }

    public long getMsgTime() {
        return msgTime;
    }

    public void setMsgTime(long msgTime) {
        this.msgTime = msgTime;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public boolean isSelf() {
        return self;
    }

    public void setSelf(boolean self) {
        this.self = self;
    }

    public String getSender() {
        return sender;
    }

    public void setSender(String sender) {
        this.sender = sender;
    }

    public String getSenderAvatar() {
        return senderAvatar;
    }

    public void setSenderAvatar(String senderAvatar) {
        this.senderAvatar = senderAvatar;
    }

    public String getSenderNickName() {
        return senderNickName;
    }

    public void setSenderNickName(String senderNickName) {
        this.senderNickName = senderNickName;
    }

    public String getReceiver() {
        return receiver;
    }

    public void setReceiver(String receiver) {
        this.receiver = receiver;
    }

    public String getExtra() {
        return extra;
    }

    public void setExtra(String extra) {
        this.extra = extra;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public WritableMap toDict() {
        WritableMap map = Arguments.createMap();
        map.putString("imgWidth", "");
        map.putString("imgHeight", "");
        map.putString("lat", "");
        map.putString("lng", "");
        if (getReceiver() != null) {
            map.putString("peer", getReceiver());
        }
        if (getSender() != null) {
            map.putString("sender", getSender());
        }
        map.putInt("msgType", getMsgType());
        map.putDouble("msgTime", getMsgTime());
        map.putBoolean("self", isSelf());
        map.putBoolean("read", isRead());
        map.putInt("status", getStatus());
        if(getSenderNickName() != null) {
            map.putString("nickName", getSenderNickName());
        }
        if(getSenderAvatar() != null) {
            map.putString("senderAvatar", getSenderAvatar());
        }
        if (getExtra() != null) {
            map.putString("extra", getExtra());
        }
        if (getDesc() != null) {
            map.putString("desc", getDesc());
        }
        return map;
    }
}
