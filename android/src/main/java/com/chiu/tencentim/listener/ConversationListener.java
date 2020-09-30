package com.chiu.tencentim.listener;

import com.chiu.tencentim.TXIMManager;
import com.chiu.tencentim.message.TXIMMessageBuilder;
import com.chiu.tencentim.module.BaseModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.tencent.imsdk.TIMConnListener;
import com.tencent.imsdk.v2.V2TIMAdvancedMsgListener;
import com.tencent.imsdk.v2.V2TIMConversation;
import com.tencent.imsdk.v2.V2TIMConversationListener;

import java.util.List;

import javax.annotation.Nonnull;

public class ConversationListener extends V2TIMConversationListener {

    protected BaseModule module;
    protected String event;

    public ConversationListener(String event) {
        this.event = event;
    }

    public void setModule(BaseModule module) {
        this.module = module;
    }

    @Override
    public void onSyncServerStart() {
        super.onSyncServerStart();
    }

    @Override
    public void onSyncServerFinish() {
        super.onSyncServerFinish();
    }

    @Override
    public void onSyncServerFailed() {
        super.onSyncServerFailed();
    }

    @Override
    public void onNewConversation(List<V2TIMConversation> conversationList) {
        super.onNewConversation(conversationList);
        TXIMManager.getInstance().updateConversationWithList(conversationList);
        this.module.sendEvent(this.event, TXIMMessageBuilder.normalizeConversationList(TXIMManager.getInstance().getConversation()));

    }

    @Override
    public void onConversationChanged(List<V2TIMConversation> conversationList) {
        super.onConversationChanged(conversationList);
        TXIMManager.getInstance().updateConversationWithList(conversationList);
        this.module.sendEvent(this.event, TXIMMessageBuilder.normalizeConversationList(TXIMManager.getInstance().getConversation()));
    }


}
