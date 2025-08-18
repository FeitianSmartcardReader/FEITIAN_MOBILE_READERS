package com.ftsafe.ireader.adapter;

import android.graphics.Bitmap;

/**
 * GradView 项
 *
 * @author Administrator
 *
 */
public class GridViewItem {
    public Bitmap bitmap;// 图片
    public String devicesName;// 题标

    // 待扩展

    public GridViewItem() {
    }

    public GridViewItem(Bitmap bitmap, String devicesName) {
        super();
        this.bitmap = bitmap;
        this.devicesName = devicesName;
    }

}
