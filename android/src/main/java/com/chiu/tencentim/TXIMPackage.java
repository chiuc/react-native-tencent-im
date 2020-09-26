package com.chiu.tencentim;

import android.os.Looper;

import androidx.annotation.MainThread;

import com.chiu.tencentim.module.InitializeModule;
import com.chiu.tencentim.module.MessageModule;
import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Nonnull;

public class TXIMPackage implements ReactPackage {

    public static InitializeModule initializeModule;

    @Nonnull
    @Override
    public List<NativeModule> createNativeModules(@Nonnull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        if (initializeModule == null) {
            initializeModule = new InitializeModule(reactContext);
        }
        modules.add(initializeModule);
        modules.add(new MessageModule(reactContext));
        return modules;
    }

    @Nonnull
    @Override
    public List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        return null;
    }

    @MainThread
    protected void init(ReactApplicationContext reactContext) {
        if (Looper.myLooper() == null) {
            Looper.prepare();
        }
        if (initializeModule != null) {
//            initializeModule.init(0);
        }
    }
}