package com.ftsafe.cardreader.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.ftsafe.cardreader.R;

import java.util.HashMap;
import java.util.List;

/**
 *
 * @author Administrator
 *
 */
public class ImageAdapter extends BaseAdapter {

    private List<HashMap<String, GridViewItem>> list;
    private GridViewItem tempGridViewItem;
    private LayoutInflater layoutInflater;

    public ImageAdapter(Context context,
                     List<HashMap<String, GridViewItem>> list) {

        this.list = list;
        layoutInflater = LayoutInflater.from(context);

    }

    /**
     * Total Count
     */
    @Override
    public int getCount() {

        return list.size();
    }

    /**
     * Get current item
     */
    @Override
    public Object getItem(int position) {

        return list.get(position);
    }

    @Override
    public long getItemId(int position) {

        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {

        View view = null;

        if (layoutInflater != null) {

            view = layoutInflater
                    .inflate(R.layout.item_devices, null);
            ImageView imageView = (ImageView) view
                    .findViewById(R.id.iv_devices_png);
            TextView textView = (TextView) view.findViewById(R.id.iv_devices_name);
            // Get custom item
            tempGridViewItem = list.get(position).get("item");
            imageView.setImageBitmap(tempGridViewItem.bitmap);
            textView.setText(tempGridViewItem.devicesName);

        }
        return view;
    }

}