import { NativeEventEmitter, NativeModules } from 'react-native';
import { EventName } from './constant';


const { TXIMInitializeModule: module } = NativeModules;
const emitter = new NativeEventEmitter(module);

export default {
    addOnlineStatusListener(listener, context) {
        return emitter.addListener(EventName.userStatus, listener, context);
    },
  
    login(identify, userSig) {
        return new Promise((resolve, reject) => {
            try {
                module.imLogin(identify, userSig);
            } catch (e) {
                reject(e);
                return;
            }
            emitter.once(EventName.loginStatus, resp => {
                resolve(resp);
            });
        });
    },
  
    logout() {
        try {
            return module.logout();
        } catch (e) {
            return Promise.reject(e);
        }
    },
};
  