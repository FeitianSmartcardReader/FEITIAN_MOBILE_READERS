package com.ftsafe.ireader.ui;

import android.app.Application;
import android.os.Handler;
import android.os.Looper;

/**
 * 版权所有：(C)飞天诚信科技股份有限公司
 * 文件名称：BaseApplication
 * 文件标识：N/A
 * 内容摘要：初始化sdk
 * 其它说明：其它内容的说明
 * 当前版本：1.0.1
 * 作    者：DYH
 * 完成日期：2018/12/16  13:51
 */
public class BaseApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();

        //放在其他库初始化前，保证崩溃不退出
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
        //保证拿到异常
        Thread.setDefaultUncaughtExceptionHandler(new Thread.UncaughtExceptionHandler() {
            @Override
            public void uncaughtException(Thread t, Throwable e) {
                e.printStackTrace();
            }
        });

    }
}
