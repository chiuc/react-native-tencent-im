import { NativeEventEmitter, NativeModules, DeviceEventEmitter } from 'react-native';
import { EventName } from './constant';


const { TXIMInitializeModule: module } = NativeModules;
// const emitter = new NativeEventEmitter(module);

export default {
    addOnlineStatusListener(listener, context) {
        return DeviceEventEmitter.addListener(EventName.loginStatus, listener, context);
    },
  
    login(identify, userSig) {
        return module.login(identify, userSig);
    },
  
    logout() {
        return module.logout();
    },
};
  