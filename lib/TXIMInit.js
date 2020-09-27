import { NativeEventEmitter, NativeModules, NativeAppEventEmitter, Platform } from 'react-native';
import { EventName } from './constant';


const { TXIMInitializeModule: module } = NativeModules;
const emitter = new NativeEventEmitter(module);

export default {
    addOnlineStatusListener(listener, context) {
        if (Platform.OS == "ios") {
            return emitter.addListener(EventName.loginStatus, listener, context);
        } else {
            return NativeAppEventEmitter.addListener(
                EventName.loginStatus,
                data => {
                    const res = {
                        data: data
                    }
                    listener(res);
                }
            );
        }
    },
  
    login(identify, userSig) {
        return module.login(identify, userSig);
    },
  
    logout() {
        return module.logout();
    },
};
  