package com.chiu.tencentim.module;

import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.lang.reflect.Method;

/**
 * Created by lovebing on 2016/10/28.
 */
abstract public class BaseModule extends ReactContextBaseJavaModule {

    protected ReactApplicationContext context;

    @Override
    public void initialize() {
        super.initialize();
        if(this.respondsToSelector("configListener")) {
            this.configListener();
        }
    }

    public BaseModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext;
    }

    public void configListener() {

    }

    /**
     *
     * @param eventName
     * @param params
     */
    public void sendEvent(String eventName, @Nullable WritableMap params) {
        context
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    /**
     *
     * @param eventName
     * @param params
     */
    public void sendEvent(String eventName, @Nullable WritableArray params) {
        context
                .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                .emit(eventName, params);
    }

    public boolean respondsToSelector(String methodName) {
        boolean result = false;
        Method method = null;
        Class objectClass = this.getClass();
        Class[] paramTypes = {};
        try {
            method = objectClass.getMethod(methodName, paramTypes);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        }

        if (method != null)
            result = true;

        return result;
    }

}
