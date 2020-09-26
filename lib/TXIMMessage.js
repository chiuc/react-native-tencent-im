import { NativeEventEmitter, NativeModules, DeviceEventEmitter } from 'react-native';
import { EventName, MessageType } from './constant';

const { TXIMMessageModule: module } = NativeModules;
// const emitter = new NativeEventEmitter(module);

export default {
    addMessageReceiveListener(listener, context) {
        return DeviceEventEmitter.addListener(EventName.onNewMessage, listener, context);
    },

    addConversationRefreshListener(listener, context) {
        return DeviceEventEmitter.addListener(EventName.onConversationRefresh, listener, context);
    },
  
    getConversation(type, peer) {
        return module.getConversation(type, peer);
    },

    getConversationList() {
        return module.getConversationList();
    },

    readMessage() {
        return module.readMessage();
    },

    getMessage(pageSize = 10, type = 1) {
        return new Promise((resolve, reject) => {
            try {
                module.getMessage(pageSize, type);
            } catch (e) {
                reject(e);
                return;
            }
            emitter.once(EventName.onMessageQuery, resp => {
                if (resp.code === 0) {
                    resolve(resp);
                } else {
                    const err = new Error(resp.msg);
                    err.code = resp.code;
                    reject(err);
                }
            });
        });
    },
  
    destroyConversation() {
        return module.destroyConversation();
    },

    sendTextMessage(text, isGroup) {
        // return module.sendMessage(MessageType.Text, text, isGroup);
        return module.sendMessage(text, isGroup);
    }

    // sendImageMsg(path, original = false) {
    //     return new Promise((resolve, reject) => {
    //         try {
    //             module.sendMessage(MessageType.Image, path, '', 0, 0, 0, !original, 0.0, 0.0);
    //         } catch (e) {
    //             reject(e);
    //             return;
    //         }
    //         emitter.once(EventName.sendStatus, resp => {
    //             if (resp.code === 0) {
    //                 resolve(true);
    //             } else {
    //                 const err = new Error(resp.msg);
    //                 err.code = resp.code;
    //                 reject(err);
    //             }
    //         });
    //     });
    // },

    // sendAudioMsg(path, duration) {
    //     return new Promise((resolve, reject) => {
    //         try {
    //             module.sendMessage(MessageType.Sound, path, '', 0, 0, duration, true, 0.0, 0.0);
    //         } catch (e) {
    //             reject(e);
    //             return;
    //         }
    //         DeviceEventEmitter.once(EventName.sendStatus, resp => {
    //             if (resp.code === 0) {
    //                 resolve(true);
    //             } else {
    //             const err = new Error(resp.msg);
    //                 err.code = resp.code;
    //                 reject(err);
    //             }
    //         });
    //     });
    // },

};