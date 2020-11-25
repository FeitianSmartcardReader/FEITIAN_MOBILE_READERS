package com.ftsafe.cardreader;

import android.app.Dialog;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnShowListener;
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
		
		// ========================= Top layout =========================
		
		LinearLayout titleLayout = new LinearLayout(context);
		titleLayout.setOrientation(LinearLayout.HORIZONTAL);
		titleLayout.setLayoutParams(lp1);
		
		tvTitle = new TextView(context);
		tvTitle.setText("select bluetooth device");
		tvTitle.setTextSize(22);
		
		progressBar = new ProgressBar(context);
		progressBar.setLayoutParams(lp2);
		progressBar.setVisibility(View.GONE);
		
		titleLayout.addView(tvTitle);
		titleLayout.addView(progressBar);
		
		// ========================= Bottom layout =========================
		
		LinearLayout buttonsLayout = new LinearLayout(context);
		buttonsLayout.setOrientation(LinearLayout.HORIZONTAL);
		buttonsLayout.setLayoutParams(lp1);
		
		btnScanStart = new Button(context);
		btnScanStop = new Button(context);
		btnClose = new Button(context);
		
		btnScanStart.setLayoutParams(lp5);
		btnScanStop.setLayoutParams(lp5);
		btnClose.setLayoutParams(lp5);
		
		btnScanStart.setText("start scan");
		btnScanStop.setText("stop scan");
		btnClose.setText("close");
		
		btnScanStart.setOnClickListener(this);
		btnScanStop.setOnClickListener(this);
		btnClose.setOnClickListener(this);
		
		btnScanStop.setVisibility(View.GONE);
		
		buttonsLayout.addView(btnScanStart);
		buttonsLayout.addView(btnScanStop);
		buttonsLayout.addView(btnClose);
		
		// ===================== Listview layout in the middle =================
		
		mListView = new ListView(context);
		mListView.setLayoutParams(lp6);
		mListView.setHeaderDividersEnabled(true);
		mListView.setFooterDividersEnabled(true);

		// ===================== Root layout ==============================
		
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
		BluetoothDevice device = listDevice.get(position);
		SelectDeviceDialog.this.cancel();
		((MainActivity)mContext).showLoading(true);
		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					mFTReader.readerOpen(device);
					((MainActivity)mContext).showLoading(false);
					mCallback.onDeviceConnected();
				} catch (FTException e) {
					e.printStackTrace();
					((MainActivity)mContext).showLoading(false);
				}
			}
		}).start();
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
