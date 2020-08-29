import { NativeEventEmitter, NativeModules } from 'react-native';
import { EventName } from './constant';


const { TXIMInitializeModule: module } = NativeModules;
const emitter = new NativeEventEmitter(module);

export default {
    addOnlineStatusListener(listener, context) {
        return emitter.addListener(EventName.loginStatus, listener, context);
    },
  
    login(identify, userSig) {
        return module.login(identify, userSig);
    },
  
    logout() {
        return module.logout();
    },
};
  