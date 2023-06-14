package com.ftsafe.cardreader.ui;

import android.app.Activity;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.WindowManager;

import androidx.annotation.Nullable;

/**
 * Copyright © 1998-2017, FEITIAN Technologies Co., Ltd. All rights reserved.
 * File Name：BaseApplication
 * File Identitier：N/A
 * Summary：Keep the screen always on
 * Description：
 * Current Version：1.0.1
 * Author：FEITIAN
 * Date：2019/1/25  15:13
 */
public class BaseActivity extends Activity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // Keep the screen on
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    // Prevent the font size from being affected by System Font Setting
    @Override
    public Resources getResources() {
        Resources res = super.getResources();
        Configuration config = new Configuration();
        config.setToDefaults();
        res.updateConfiguration(config, res.getDisplayMetrics());
        return res;
    }

}
