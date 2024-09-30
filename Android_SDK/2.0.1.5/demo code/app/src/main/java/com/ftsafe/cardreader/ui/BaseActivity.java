package com.ftsafe.cardreader.ui;

import android.app.Activity;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.WindowManager;

import androidx.annotation.Nullable;

/**
 * 版权所有：(C)飞天诚信科技股份有限公司
 * 文件名称：BaseActivity
 * 文件标识：N/A
 * 内容摘要：基类，保持屏幕常亮
 * 其它说明：其它内容的说明
 * 当前版本：1.3
 * 作    者：DYH
 * 完成日期：2019/1/25  15:13
 */
public class BaseActivity extends Activity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        //保持屏幕长亮
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
    }

    //字体大小不受系统字体大小改变的影响
    @Override
    public Resources getResources() {
        Resources res = super.getResources();
        Configuration config = new Configuration();
        config.setToDefaults();
        res.updateConfiguration(config, res.getDisplayMetrics());
        return res;
    }

}
