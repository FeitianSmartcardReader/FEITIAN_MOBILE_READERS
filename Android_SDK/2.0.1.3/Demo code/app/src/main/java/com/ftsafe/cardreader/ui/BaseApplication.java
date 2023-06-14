package com.ftsafe.cardreader.ui;

import android.app.Application;
import android.os.Handler;
import android.os.Looper;

/**
 * Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
 * File Name：BaseApplication
 * File Identitier：N/A
 * Summary：Initialize SDK
 * Description：
 * Current Version：1.0.1
 * Author：FEITIAN
 * Date：2018/12/16  13:51
 */
public class BaseApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        // Put this code before initialize all other libs,
		// to ensure the App do not terminate while encountering crash event
        new Handler(Looper.getMainLooper()).post(new Runnable()
        {
            @Override
            public void run()
            {
                while (true)
                {
                    try
                    {
                        Looper.loop();
                    }
                    catch (Throwable localThrowable) {}
                }
            }
        });
        
		// To ensure getting exception code
        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread t, Throwable e) {
                e.printStackTrace();
            }
        });

    }
}
