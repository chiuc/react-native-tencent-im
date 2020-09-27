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
import java.util.Collections;
import java.util.List;

import javax.annotation.Nonnull;

public class TXIMPackage implements ReactPackage {

    public static InitializeModule initializeModule;

    @Nonnull
    @Override
    // Important: This function will be re-called during reload
    // reactContext will be changed
    public List<NativeModule> createNativeModules(@Nonnull ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();

        modules.add(new InitializeModule(reactContext));
        modules.add(new MessageModule(reactContext));
        return modules;
    }

    @Nonnull
    @Override
    public List<ViewManager> createViewManagers(@Nonnull ReactApplicationContext reactContext) {
        // Required to provide emtpy list instead of null
        return Collections.emptyList();
    }

    @MainThread
    protected void init(ReactApplicationContext reactContext) {
        if (Looper.myLooper() == null) {
            Looper.prepare();
        }
    }
}
