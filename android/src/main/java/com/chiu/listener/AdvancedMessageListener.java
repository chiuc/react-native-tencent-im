package com.chiu.tencentim.listener;

import com.chiu.tencentim.message.TXIMMessageBuilder;
import com.chiu.tencentim.message.TXIMMessageInfo;
import com.chiu.tencentim.module.BaseModule;
import com.tencent.imsdk.v2.V2TIMAdvancedMsgListener;
import com.tencent.imsdk.v2.V2TIMMessage;
import com.tencent.imsdk.v2.V2TIMMessageReceipt;

import java.util.List;

public class AdvancedMessageListener extends V2TIMAdvancedMsgListener {
    protected BaseModule module;
    protected String event;

    public AdvancedMessageListener(BaseModule module, String event) {
        this.module = module;
        this.event = event;
    }

    @Override
    public void onRecvNewMessage(V2TIMMessage msg) {
        super.onRecvNewMessage(msg);
        TXIMMessageInfo info = TXIMMessageBuilder.buildMessageWithTIMMessage(msg);
        module.sendEvent(event, info.toDict());
    }

    @Override
    public void onRecvMessageRevoked(String msgID) {
        super.onRecvMessageRevoked(msgID);
    }

    @Override
    public void onRecvC2CReadReceipt(List<V2TIMMessageReceipt> receiptList) {
        super.onRecvC2CReadReceipt(receiptList);
    }
}
