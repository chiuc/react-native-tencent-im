package com.chiu.tencentim;

import android.app.Application;
import android.content.Context;

import com.chiu.tencentim.utils.Foreground;

public class TXIMApplication {
    private static Context context;

    private static Class mainActivityClass;

    public static void setContext(final Context context, Class mainActivityClass) {
        Foreground.init((Application)context);
        TXIMApplication.context = context.getApplicationContext();
        TXIMApplication.mainActivityClass = mainActivityClass;
    }

    public static Context getContext() {
        return context;
    }

    public static Class getMainActivityClass() {
        return mainActivityClass;
    }


}
