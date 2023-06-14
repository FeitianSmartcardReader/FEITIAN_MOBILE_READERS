package com.ftsafe.cardreader.adapter;

import android.graphics.Bitmap;

/**
 * GradView Item
 *
 * @author Administrator
 *
 */
public class GridViewItem {
    public Bitmap bitmap;// Image
    public String devicesName;// Title

    // To extend

    public GridViewItem() {
    }

    public GridViewItem(Bitmap bitmap, String devicesName) {
        super();
        this.bitmap = bitmap;
        this.devicesName = devicesName;
    }

}
