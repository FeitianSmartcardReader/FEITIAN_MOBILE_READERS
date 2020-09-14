package com.ftsafe.cardreader;

import android.app.Dialog;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnShowListener;
import android.content.DialogInterface.OnCancelListener;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

import java.util.ArrayList;
import java.util.List;

public class SelectDeviceDialog extends Dialog implements View.OnClickListener, OnItemClickListener, OnShowListener, OnCancelListener {

	private TextView tvTitle;
	private ProgressBar progressBar;
	private ListView mListView;
	private Button btnScanStart;
	private Button btnScanStop;
	private Button btnClose;
	
	private SelectCallback mCallback;
	private ArrayAdapter<String> mDeviceListAdapter;
	List<BluetoothDevice> listDevice;
	List<String> listDeviceName;
	Context mContext;

	FTReader mFTReader;
	
	public SelectDeviceDialog(Context context, FTReader reader, SelectCallback callback) {
		super(context);

		mContext = context;
		intiUI(context);
		
		mCallback = callback;
		listDevice = new ArrayList<>();
		listDeviceName = new ArrayList<>();
		
		mDeviceListAdapter = new ArrayAdapter<>(context, android.R.layout.simple_list_item_1, listDeviceName);
		mListView.setAdapter(mDeviceListAdapter);
		mListView.setOnItemClickListener(this);
		
		setCancelable(false);
		this.setOnShowListener(this);
		setOnCancelListener(this);

		mFTReader = reader;
	}

	private void intiUI(Context context) {
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		
		ViewGroup.LayoutParams lp1 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		ViewGroup.LayoutParams lp2 = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.FILL_PARENT);
		LinearLayout.LayoutParams lp5 = new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1);
		LinearLayout.LayoutParams lp6 = new LinearLayout.LayoutParams(ViewGroup.LayoutParams.FILL_PARENT, 0, 1);
		
		// ========================= 顶部布局 =========================
		
		LinearLayout titleLayout = new LinearLayout(context);
		titleLayout.setOrientation(LinearLayout.HORIZONTAL);
		titleLayout.setLayoutParams(lp1);
		
		tvTitle = new TextView(context);
		tvTitle.setText("选择设备");
		tvTitle.setTextSize(22);
		
		progressBar = new ProgressBar(context);
		progressBar.setLayoutParams(lp2);
		progressBar.setVisibility(View.GONE);
		
		titleLayout.addView(tvTitle);
		titleLayout.addView(progressBar);
		
		// ========================= 底部布局 =========================
		
		LinearLayout buttonsLayout = new LinearLayout(context);
		buttonsLayout.setOrientation(LinearLayout.HORIZONTAL);
		buttonsLayout.setLayoutParams(lp1);
		
		btnScanStart = new Button(context);
		btnScanStop = new Button(context);
		btnClose = new Button(context);
		
		btnScanStart.setLayoutParams(lp5);
		btnScanStop.setLayoutParams(lp5);
		btnClose.setLayoutParams(lp5);
		
		btnScanStart.setText("开始扫描");
		btnScanStop.setText("停止扫描");
		btnClose.setText("关闭");
		
		btnScanStart.setOnClickListener(this);
		btnScanStop.setOnClickListener(this);
		btnClose.setOnClickListener(this);
		
		btnScanStop.setVisibility(View.GONE);
		
		buttonsLayout.addView(btnScanStart);
		buttonsLayout.addView(btnScanStop);
		buttonsLayout.addView(btnClose);
		
		// ===================== 中部的 ListView 布局 =================
		
		mListView = new ListView(context);
		mListView.setLayoutParams(lp6);
		mListView.setHeaderDividersEnabled(true);
		mListView.setFooterDividersEnabled(true);

		// ===================== 根布局 ==============================
		
		LinearLayout rootLayout = new LinearLayout(context);
		rootLayout.setOrientation(LinearLayout.VERTICAL);
		
		rootLayout.addView(titleLayout);
		rootLayout.addView(mListView);
		rootLayout.addView(buttonsLayout);
		
		setContentView(rootLayout);
	}
	
	@Override
	public void onClick(View v) {
		if (v == btnClose) {
			this.cancel();
		} else if (v == btnScanStart) {
			try {
				mFTReader.readerFind();
			} catch (FTException e) {
				e.printStackTrace();
			}
			btnScanStart.setVisibility(View.GONE);
			btnScanStop.setVisibility(View.VISIBLE);
			progressBar.setVisibility(View.VISIBLE);
		} else if (v == btnScanStop) {
			try {
				mFTReader.readerClose();
			} catch (FTException e) {
				e.printStackTrace();
			}
			btnScanStart.setVisibility(View.VISIBLE);
			btnScanStop.setVisibility(View.GONE);
			progressBar.setVisibility(View.GONE);
		}
	}

	public void setCallback(SelectCallback callback){
		mCallback = callback;
	}

	public void setData(BluetoothDevice device){
		if(!listDeviceName.contains(device.getName())){
			listDevice.add(device);
			listDeviceName.add(device.getName());
			mDeviceListAdapter.notifyDataSetChanged();
		}
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
		SelectDeviceDialog.this.cancel();
		try {
			mFTReader.readerOpen(listDevice.get(position));
			mCallback.onDeviceConnected();
		} catch (FTException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onShow(DialogInterface dialog) {
		btnScanStart.performClick();
	}

	@Override
	public void onCancel(DialogInterface dialog) {
		listDevice.clear();
		listDeviceName.clear();
		mDeviceListAdapter.notifyDataSetChanged();
	}

	public static interface SelectCallback {
		void onDeviceConnected();
	}
}
