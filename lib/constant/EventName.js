import { NativeModules, Platform } from 'react-native';

const { TXIMInitializeModule: module } = NativeModules;

const eventName = (name) => {
    return module.EventName[name];
};

export default {
  loginStatus: eventName('loginStatus'),
  initializeStatus: eventName('initializeStatus'),
  userStatus: eventName('userStatus'),
  sendStatus: eventName('sendStatus'),
  onNewMessage: eventName('onNewMessage'),
  conversationStatus: eventName('conversationStatus'),
  conversationListStatus: eventName('conversationListStatus'),
  onConversationRefresh: eventName('onConversationRefresh'),
  onMessageQuery: eventName('onMessageQuery'),
};
