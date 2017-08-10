package com.example.ftbtdemo;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.DialogInterface;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;

import com.feitian.readerdk.Tool.DK;

/**
 * This is the main Activity that displays the current chat session.
 */
public class BlueTooth extends Activity implements OnClickListener {
	// 宏消息定义
	private static final boolean Debug = true;
	private static final String TAG = "Bluetooth";
	// Key names received from the BluetoothService Handler
	public static final String DEVICE_NAME = "device_name";
	public static final String TOAST = "toast";

	// 控件、
	private Button mSend;
	private Button mList;
	private Button mConnect;
	private Button mDisConnect;
	private Button mPowerOn;
	private Button mPowerOff;
	private Button mGetatr;
	private Button mExit;
	private Button mclearReceiveData;
	private Button mGetCardSerialNum;
	private Button mWriteFlash;
	private Button mReadFlash;
	private Button mSendCmd;
	// private Button mDisconnect;
	private Button mGetStatus;
	private EditText mEditSend;// 发送数据
	private EditText mEditFlash;// 发送flash数据
	private EditText mEditReceive;
	private Spinner deviceListSpinner;

	private ft_reader mReader;
	private Spinner devListSpinner2;
	private String selectStr = "";

	private ArrayAdapter<String> mAdapter;
	ArrayList<String> list;
	ArrayList<BluetoothDevice> arrayForBlueToothDevice;
	//
	private List<String> list2 = new ArrayList<String>();
	private List<String> list3 = new ArrayList<String>();
	private ArrayAdapter<String> adapter;

	private static final UUID MY_UUID = UUID
			.fromString("00001101-0000-1000-8000-00805F9B34FB");
	// for test
	BluetoothDevice mBlueToothDevice;
	BluetoothAdapter mBlueToothAdapter = null;
	BluetoothSocket mBlueToothSocket;
	InputStream mInput;
	OutputStream mOutput;
	private int testi = 0;

	@Override
	public void onCreate(Bundle savedInstanceState) {

		if (Debug)
			Log.e(TAG, "===onCreate==");
		super.onCreate(savedInstanceState);

		if (isTabletDevice()) {
			setContentView(R.layout.title_activity_ft_bt_demo);
		} else {
			setContentView(R.layout.activity_phone);
		}
		mBlueToothAdapter = BluetoothAdapter.getDefaultAdapter();

		if (mBlueToothAdapter == null) {
			Toast.makeText(this, "this device don't support bluetooth",
					Toast.LENGTH_LONG).show();
			finish();
			return;
		}
		mSend = (Button) findViewById(R.id.BSendData);
		mSend.setOnClickListener(this);
		mList = (Button) findViewById(R.id.BList);
		mList.setOnClickListener(this);
		mConnect = (Button) findViewById(R.id.Bconnect);
		mConnect.setOnClickListener(this);
		mDisConnect = (Button) findViewById(R.id.BdisConnect);
		mDisConnect.setOnClickListener(this);
		mExit = (Button) findViewById(R.id.BExit);
		mExit.setOnClickListener(this);
		mclearReceiveData = (Button) findViewById(R.id.BclearReceiveData);
		mclearReceiveData.setOnClickListener(this);
		mPowerOn = (Button) findViewById(R.id.BPowerOn);
		mPowerOn.setOnClickListener(this);
		mPowerOff = (Button) findViewById(R.id.BPowerOff);
		mPowerOff.setOnClickListener(this);
		mGetatr = (Button) findViewById(R.id.BGetAtr);
		mGetatr.setOnClickListener(this);
		mGetStatus = (Button) findViewById(R.id.BGetStatus);
		mGetStatus.setOnClickListener(this);
		mGetCardSerialNum = (Button) findViewById(R.id.BGetSerial);
		mGetCardSerialNum.setOnClickListener(this);

		mWriteFlash = (Button) findViewById(R.id.BWriteFlash);
		mWriteFlash.setOnClickListener(this);

		mReadFlash = (Button) findViewById(R.id.BReadFlash);
		mReadFlash.setOnClickListener(this);

		mEditSend = (EditText) findViewById(R.id.ESendData);
		mEditSend.setText("0084000008");

		mEditFlash = (EditText) findViewById(R.id.EWriteFlash);
		mEditFlash.setText("12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
				+"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"
				+"12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890");

		mEditFlash.setText("0084000049");
		mEditReceive = (EditText) findViewById(R.id.Ereceive);

		deviceListSpinner = (Spinner) findViewById(R.id.spinner1);

		mSendCmd = (Button) findViewById(R.id.BSendCmd);
		mSendCmd.setOnClickListener(this);

		/* 获取 */
		arrayForBlueToothDevice = new ArrayList<BluetoothDevice>();

		list = new ArrayList<String>();
		mAdapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_spinner_item, list);
		mAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		deviceListSpinner.setAdapter(mAdapter);
		deviceListSpinner
				.setOnItemSelectedListener(new Spinner.OnItemSelectedListener() {
					@Override
					public void onItemSelected(AdapterView<?> arg0, View arg1,
							int arg2, long arg3) {
						// TODO Auto-generated method stub
						if (Debug)
							Log.e(TAG, "select device " + list.get(arg2));
						mBlueToothDevice = arrayForBlueToothDevice.get(arg2);
						Log.e(TAG, "" + mBlueToothDevice.getAddress() + "  "
								+ mBlueToothDevice.getName());
					}

					@Override
					public void onNothingSelected(AdapterView<?> arg0) {
						// TODO Auto-generated method stub
					}
				});

		devListSpinner2 = (Spinner) findViewById(R.id.spinner2);
		// step 1
		list3.add("cmd 1 00A404000A01020304050607081000"); list2.add("00A404000A01020304050607081000");
		list3.add("cmd 2 801000030000"); list2.add("801000030000");
		
		
		
		// step 2 为下拉列表定义一个适配器，用到定义的额list2
		adapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_spinner_item, list3);
		// step 3 select style for 下拉列表
		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		// step 4 将适配器添加到下拉列表上
		devListSpinner2.setAdapter(adapter);

		devListSpinner2
				.setOnItemSelectedListener(new Spinner.OnItemSelectedListener() {

					@Override
					public void onItemSelected(AdapterView<?> arg0, View arg1,
							int arg2, long arg3) {
						selectStr = list2.get(arg2);
					}

					@Override
					public void onNothingSelected(AdapterView<?> arg0) {
						displayData("system", "select cmd first");
					}
				});

		stat_disconnect();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case DK.CARD_STATUS:
				switch (msg.arg1) {
				case DK.CARD_ABSENT:
					displayData("IFD", "card absent");
					stat_poweroff();
					break;
				case DK.CARD_PRESENT:
					displayData("IFD", "card persent");
					// try {
					// mReader.PowerOff();
					// mReader.PowerOn();
					// } catch (FtBlueReadException e) {
					// // TODO Auto-generated catch block
					// e.printStackTrace();
					// }
					break;
				case DK.CARD_UNKNOWN:
					displayData("IFD", "card unknown");
					break;
				case DK.IFD_COMMUNICATION_ERROR:
					displayData("IFD", "IFD error");
					break;
				}
			default:
				break;
			}
		}
	};

	@SuppressLint("NewApi")
	@Override
	public void onClick(View v) {
		// TODO Auto-generated method stub
		if (v == mList) {
			mAdapter.clear();
			list.clear();
			arrayForBlueToothDevice.clear();
			Set<BluetoothDevice> pairedDevices = mBlueToothAdapter
					.getBondedDevices();
			if (pairedDevices.size() > 0) {
				for (BluetoothDevice device : pairedDevices) {
					String str = device.getName();
					if (null != str && (-1 != str.indexOf("FT"))) {
						mAdapter.add(device.getName());
						arrayForBlueToothDevice.add(device);
					}
				}
			}
			// doDiscovery();
		} else if (v == mConnect) {
			if (mBlueToothDevice == null) {
				displayData("System", "select device first");
				return;
			}
			try {
				mBlueToothSocket = mBlueToothDevice
						.createInsecureRfcommSocketToServiceRecord(MY_UUID);
				mBlueToothSocket.connect();
				mInput = mBlueToothSocket.getInputStream();
				mOutput = mBlueToothSocket.getOutputStream();
				mReader = new ft_reader(mInput, mOutput);
				displayData("System", "create socket ok");
				displayData("DK", "Version:" + mReader.getDkVersion());
				//
				mReader.registerCardStatusMonitoring(mHandler);
				//
				stat_connect();
			} catch (IOException e) {
				displayData("System", "create socket error");
				e.printStackTrace();
			} catch (FtBlueReadException e) {
				displayData("IFD", e.toString());
			}

		} else if (v == mDisConnect) {
			try {
				mReader.PowerOff();
				mReader.readerClose();
				mBlueToothSocket.close();
				mBlueToothSocket = null;
			} catch (IOException e) {
				e.printStackTrace();
			} catch (FtBlueReadException e) {
				e.printStackTrace();
			}
			stat_disconnect();
		} else if (v == mSend) {
			String str = mEditSend.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										mEditSend.setText("");
									}
								}).show();
			} else {
				byte[] tmp = Tool.hexStringToBytes(str);
				displayData("Send", str);
				byte[] rev = new byte[1024];
				int[] length = new int[2];
				int ret = DK.RETURN_SUCCESS;
				try {
					ret = mReader.transApdu(tmp.length, tmp, length, rev);
					displayData("Receive", Tool.byte2HexStr(rev, length[0]));
				} catch (FtBlueReadException e) {
					// TODO Auto-generated catch block
					displayData("Receive", e.toString());
				}
			}

		} else if (v == mPowerOn) {

			try {
				mReader.PowerOn();
				displayData("PowerON", "success");
				stat_poweron();
			} catch (FtBlueReadException e) {
				displayData("PowerON", "faild");
			}
		} else if (v == mPowerOff) {
			try {
				mReader.PowerOff();
				displayData("mPowerOff", "success");
				stat_poweroff();
			} catch (FtBlueReadException e) {
				displayData("mPowerOff", e.toString());
			}

		} else if (v == mGetatr) {
			try {
				byte atr[] = mReader.getAtr();
				if (atr == null)
					return;
				byte[] versionBuf = new byte[128];
				int[] versionBufLen = new int[1];
				mReader.getVersion(versionBuf, versionBufLen);
				displayData(
						"info",
						"atr:" + Tool.byte2HexStr(atr, atr.length)
								+ "\n==>protocol: T"
								+ Integer.toString(mReader.getProtocol())
								+ "\nReader Version:" + versionBuf[0] + '.'+String.format("%x", versionBuf[1]));
			} catch (FtBlueReadException e) {
				displayData("mGetatr", e.toString());
			}
			
		} else if (v == mGetStatus) {
			int ret = 0;
			try {
				ret = mReader.getCardStatus();
			} catch (FtBlueReadException e) {
				displayData("mGetStatus", e.toString());
			}
			if (ret == DK.CARD_ABSENT) {
				displayData("GetStatus", "card absent");
			} else if (ret == DK.CARD_PRESENT) {
				displayData("GetStatus", "card present");
			} else {
				displayData("GetStatus", "card unknow");
			}
		} else if (v == mGetCardSerialNum) {
			byte serialNum[] = new byte[128];
			int serialLen[] = new int[1];
			mReader.getSerialNum(serialNum, serialLen);
			serialNum[serialLen[0]] = '\0';
			String str = new String(serialNum);
			displayData("GetSerialNum", str);
		} else if (v == mReadFlash) {
			byte buf[] = new byte[512];
			if (DK.RETURN_SUCCESS == mReader.readFlash(buf, 0, 255)) {
				displayData("readFlash[255]", Tool.byte2HexStr(buf, 255));
			} else {
				displayData("readFlash", "error");
			}
		} else if (v == mSendCmd) {
			if (null == mReader) {
				displayData("System", "connect device first");
			} else if (!mReader.isPowerOn()) {
				displayData("Reader", "power on first");
			} else {
				byte[] tmp = Tool.hexStringToBytes(selectStr);
				displayData("Send", selectStr);
				byte[] rev = new byte[1024];
				int[] length = new int[2];
				int ret = DK.RETURN_SUCCESS;
				try {
					ret = mReader.transApdu(tmp.length, tmp, length, rev);
					displayData("Receive", Tool.byte2HexStr(rev, length[0]));
				} catch (FtBlueReadException e) {
					// TODO Auto-generated catch block
					displayData("Receive", e.toString());
				}
			}
		} else if (v == mWriteFlash) {
			String str = mEditFlash.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
									}
								}).show();
				return;
			}
			byte sendcmd[] = Tool.hexStringToBytes(str);
			if (str.length() == 0) {
				displayData("WriteFlash", "text null");
			} else {
				if (DK.RETURN_SUCCESS == mReader.writeFlash(sendcmd, 0,
						sendcmd.length)) {
					displayData("WriteFlash["+sendcmd.length+"]", "success");
				} else {
					displayData("writeFlash", "error");
				}
			}
		} else if (v == mclearReceiveData) {
			mEditReceive.setText("");
		} else if (v == mExit) {
			new AlertDialog.Builder(BlueTooth.this)
					.setTitle("prompt")
					.setMessage("Do you want to leave?")
					.setPositiveButton("YES",
							new DialogInterface.OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									finish();
								}
							})
					.setNegativeButton("NO",
							new DialogInterface.OnClickListener() {
								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									// do nothing
								}
							}).show();
		}
	}

	private void stat_poweroff() {
		mPowerOn.setEnabled(true);
		mPowerOff.setEnabled(false);
		mGetatr.setEnabled(false);
		mSend.setEnabled(false);
		mSendCmd.setEnabled(false);
	}

	private void stat_disconnect() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(false);
		mGetatr.setEnabled(false);
		mGetStatus.setEnabled(false);
		mSend.setEnabled(false);
		mConnect.setEnabled(true);
		mDisConnect.setEnabled(false);
		mGetCardSerialNum.setEnabled(false);
		mWriteFlash.setEnabled(false);
		mReadFlash.setEnabled(false);
		mSendCmd.setEnabled(false);
	}

	private void stat_poweron() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(true);
		mGetatr.setEnabled(true);
		mSend.setEnabled(true);
		mSendCmd.setEnabled(true);
	}

	private void stat_connect() {
		mPowerOn.setEnabled(true);
		mPowerOff.setEnabled(false);
		mGetatr.setEnabled(false);
		mGetStatus.setEnabled(true);
		mSend.setEnabled(false);
		mConnect.setEnabled(false);
		mDisConnect.setEnabled(true);
		mGetCardSerialNum.setEnabled(true);
		mWriteFlash.setEnabled(true);
		mReadFlash.setEnabled(true);
		mSendCmd.setEnabled(false);
	}

	@Override
	public void onStart() {
		super.onStart();
	}

	@Override
	public synchronized void onResume() {
		super.onResume();
	}

	@Override
	public synchronized void onPause() {
		super.onPause();
	}

	@Override
	public void onStop() {
		super.onStop();
	}

	@Override
	public void onDestroy() {
		Log.d("system", "OnDestroy()");
		super.onDestroy();
		try {
			if (null != mReader) {
				mReader.readerClose();
				mReader = null;
			}
			if (null != mBlueToothSocket) {
				mBlueToothSocket.close();
				mBlueToothSocket = null;
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void displayData(String Tag, String text) {
		SimpleDateFormat formatter = new SimpleDateFormat("  HH:mm:ss");
		Date curDate = new Date(System.currentTimeMillis());// 获取当前时间
		String str = formatter.format(curDate);
		if (text.length() > 0) {
			mEditReceive.setText(mEditReceive.getText() + "From:" + Tag + str
					+ "\n==>" + text + "\n");
		}
	}

	private boolean isLegal(String dataSendStr) {
		// TODO Auto-generated method stub
		if (dataSendStr.length() == 0)
			return false;
		for (int i = 0; i < dataSendStr.length(); i++) {
			if (!(((dataSendStr.charAt(i) >= '0') && (dataSendStr.charAt(i) <= '9'))
					|| ((dataSendStr.charAt(i) >= 'a') && (dataSendStr
							.charAt(i) <= 'f')) || ((dataSendStr.charAt(i) >= 'A') && (dataSendStr
					.charAt(i) <= 'F')))) {
				return false;
			}
		}
		return true;
	}

	private boolean isTabletDevice() {
		if (android.os.Build.VERSION.SDK_INT >= 11) { // honeycomb
			// test screen size, use reflection because isLayoutSizeAtLeast is
			// only available since 11
			Configuration con = getResources().getConfiguration();
			try {
				Method mIsLayoutSizeAtLeast = con.getClass().getMethod(
						"isLayoutSizeAtLeast", int.class);
				Boolean r = (Boolean) mIsLayoutSizeAtLeast.invoke(con,
						0x00000004); // Configuration.SCREENLAYOUT_SIZE_XLARGE
				return r;
			} catch (Exception x) {
				x.printStackTrace();
				return false;
			}
		}
		return false;
	}
}