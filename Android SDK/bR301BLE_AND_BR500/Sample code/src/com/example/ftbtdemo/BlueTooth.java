package com.example.ftbtdemo;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothManager;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.content.DialogInterface;
import android.content.IntentFilter;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.content.res.Configuration;
import android.os.AsyncTask;
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

import com.feitianBLE.readerdk.Tool.DK;

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
	public boolean mScanning;	
	private ProgressDialog pdlg;
	
	private final int Max_Packet_length = 2048;
	
	private final int Max_Flash_length = 2048;
	// 控件、
	private Button mSend;
	private Button mSend1;
	private Button mList;
	private Button mConnect;
	private Button mDisConnect;
	private Button mPowerOn;
	private Button mPowerOff;
	private Button BgetUserID;
	private Button BgenUserID;
	private Button BeraseUserID;
	private EditText seedData;
	private Button BgetHardID;
	private Button mExit;
	private Button mclearReceiveData;
	
	private String apdu_stirng;
	private ArrayAdapter<String> mAdapter1;
	ArrayList<String> list1;
	private Spinner apduListSpinner;
	
	private Button mGetStatus;
	private Button BGetVersion;
	private EditText mEditSend;

	private Button BReadFlash;
	private Button BWriteFlash;
	private EditText EFlash;
	private EditText Eoffset;
	private EditText Elength;

	private EditText mEditReceive;
	private Spinner deviceListSpinner;

	private ft_reader mReader;

	private ArrayAdapter<String> mAdapter;
	ArrayList<String> list;
	ArrayList<BluetoothDevice> arrayForBlueToothDevice;
	//
	private List<String> list3 = new ArrayList<String>();
	private ArrayAdapter<String> adapter;

	;
	// for test
	BluetoothDevice mBlueToothDevice;
	BluetoothAdapter mBlueToothAdapter = null;
	BluetoothSocket mBlueToothSocket;
	InputStream mInput;
	OutputStream mOutput;

	private BluetoothAdapter mBluetoothAdapter;

	private BlueToothReceiver receiver;

	@Override
	public void onCreate(Bundle savedInstanceState) {

		if (Debug)
			Log.e(TAG, "===onCreate==");
		super.onCreate(savedInstanceState);

		if (isTabletDevice()) {
			setContentView(R.layout.title_activity_ft_bt_demo);
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
//			setContentView(R.layout.activity_phone);
		} else {
			setContentView(R.layout.activity_phone);
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		}
		
		
		if (!getPackageManager().hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE)) {
            Toast.makeText(this, "error_bluetooth_not_supported", Toast.LENGTH_SHORT).show();
            finish();
        }
        final BluetoothManager bluetoothManager =
                (BluetoothManager) getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();
        
        // Checks if Bluetooth is supported on the device.
        if (mBluetoothAdapter == null) {
            Toast.makeText(this, "error_bluetooth_not_supported", Toast.LENGTH_SHORT).show();
            finish();
            return;
        }
    
    mBluetoothAdapter.enable();
    
    	Init_UI();

		
		//To monitor reader connection status
		//#1, register card status monitoring
		BlueToothReceiver.registerCardStatusMonitoring(mHandler);
		
		//MyBroadcastReceiver
		receiver=new BlueToothReceiver();
		IntentFilter filter=new IntentFilter();
		filter.addAction("android.bluetooth.device.action.ACL_CONNECTED");
		filter.addAction("android.bluetooth.device.action.ACL_DISCONNECTED");
		filter.addAction("android.bluetooth.device.action.FOUND");
		filter.addAction("android.bluetooth.device.action.ACL_DISCONNECT_REQUESTED");
		//register receiver
		registerReceiver(receiver, filter);
	}

	private void Init_UI() {
		
		pdlg = new ProgressDialog(this);
		pdlg.setMessage("Waiting");
		pdlg.setCancelable(false);
		
		mSend = (Button) findViewById(R.id.BSendData);
		mSend.setOnClickListener(this);
		mSend1 = (Button) findViewById(R.id.BSend);
		mSend1.setOnClickListener(this);
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
		BgetHardID = (Button) findViewById(R.id.BGetSerial);
		BgetHardID.setOnClickListener(this);
		
		BgetUserID = (Button) findViewById(R.id.BgetUserID);
		BgetUserID.setOnClickListener(this);
		BgenUserID = (Button) findViewById(R.id.BgenUserID);
		BgenUserID.setOnClickListener(this);
		BeraseUserID = (Button) findViewById(R.id.BeraseUserID);
		BeraseUserID.setOnClickListener(this);
		seedData = (EditText) findViewById(R.id.ESeedData);
		seedData.setText("FFFFFFFF");
		
		BReadFlash = (Button) findViewById(R.id.BReadFlash);
		BReadFlash.setOnClickListener(this);
		BWriteFlash = (Button) findViewById(R.id.BWriteFlash);
		BWriteFlash.setOnClickListener(this);
		EFlash = (EditText) findViewById(R.id.EWriteFlash);
		EFlash.setText("00010203040506070809");
		Eoffset = (EditText) findViewById(R.id.Eoffset);
		Eoffset.setText("00");
		Elength = (EditText) findViewById(R.id.Elength);
		Elength.setText("00");
		
		mGetStatus = (Button) findViewById(R.id.BGetStatus);
		mGetStatus.setOnClickListener(this);
		BGetVersion = (Button) findViewById(R.id.BGetVersion);
		BGetVersion.setOnClickListener(this);
		mEditSend = (EditText) findViewById(R.id.ESendData);
		mEditSend.setText("0084000008");

		
		mEditReceive = (EditText) findViewById(R.id.Ereceive);

		deviceListSpinner = (Spinner) findViewById(R.id.spinner1);
		
		mBluetoothAdapter.enable();
		
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

			
		adapter = new ArrayAdapter<String>(this,
				android.R.layout.simple_spinner_item, list3);

		adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
		apduListSpinner = (Spinner) findViewById(R.id.spinner2);
		list1 = new ArrayList<String>();
		mAdapter1 = new ArrayAdapter<String>(this,
				android.R.layout.simple_spinner_item, list1);
		
		mAdapter1.add("0084000008");
		mAdapter1.add("java card command as follow:");
		mAdapter1.add("008400007F");
		mAdapter1.add("00A4040008D156000001010301");
		mAdapter1.add("00A40000023F00");
		mAdapter1.add("00e4010002a001");
		mAdapter1.add("00e00000186216820238008302a00185020000860800000000000000ff");
		mAdapter1.add("00A4000002A001");
		mAdapter1.add("00E00000186216820201018302B001850200ff86080000000000000000");
		mAdapter1.add("00D60000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849");
		mAdapter1.add("00D60000FB0001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950");
		mAdapter1.add("00D60000FF000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354");
		mAdapter1.add("00b00000FF");
		mAdapter1.add("00A40000023F00");
		mAdapter1.add("00A4000002A001");
		mAdapter1.add("00e4020002B001");
		mAdapter1.add("00A40000023F00");
		mAdapter1.add("00e4010002a001");
		mAdapter1.add("ben_262 card as follow");
		mAdapter1.add("00a404000a01020304050607080900");
		mAdapter1.add("8010010600");
		mAdapter1.add("8020000001");

		mAdapter1.add("80300000FB0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
		mAdapter1.add("8030000000010600010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061");
		mAdapter1.add("8010010600");
		mAdapter1.add("black-white type B");
		mAdapter1.add("00A404000BA000000291A00000019102");
		mAdapter1.add("00B201A420");
		mAdapter1.add("00B201AC40");
		mAdapter1.add("select app, write 128,read,write 250,read,write 256,read");
		mAdapter1.add("00A40400051122334455");
		mAdapter1.add("128bytes");
		mAdapter1.add("0001000080f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3");
		mAdapter1.add("00020000");
		mAdapter1.add("250bytes");
		mAdapter1.add("00010000FAf22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74");
		mAdapter1.add("00020000");
		mAdapter1.add("256bytes");
		mAdapter1.add("00010000000100016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
		mAdapter1.add("00020000");
		mAdapter1.add("262bytes");
		mAdapter1.add("00010000000106016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395112233445566");
		mAdapter1.add("00020000");
		mAdapter1.add("300bytes");
		mAdapter1.add("0001000000012Cff001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899");
		mAdapter1.add("00020000");
		mAdapter1.add("512bytes");
		mAdapter1.add("00010000000200016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
		mAdapter1.add("00020000");
		mAdapter1.add("1024bytes");
		mAdapter1.add("00010000000400016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
		mAdapter1.add("00020000");
		mAdapter1.add("2048bytes");
		mAdapter1.add("00010000000800016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
		mAdapter1.add("00020000");
		mAdapter1.add("com");
		mAdapter1.add("00A40400050102030405" );
		mAdapter1.add("8010007000" );
		mAdapter1.add("8010012100");
		mAdapter1.add("card return");
		mAdapter1.add("00A404000A01020304050607080900");
		mAdapter1.add("80200000EE" );
		mAdapter1.add("80200000EF" );
		mAdapter1.add("80200000F0" );
		mAdapter1.add("80200000F1" );
		mAdapter1.add("80200000FE" );
		mAdapter1.add("80200000FF" );
		mAdapter1.add("801000e3000000");
		mAdapter1.add("802000000003e3");
		mAdapter1.add("801000f100");
		mAdapter1.add("timeout 0--0x40");
		mAdapter1.add("00A404000A01020304050607081000");
		mAdapter1.add("8010000000" );
		mAdapter1.add("8010000100" );
		mAdapter1.add("8010000200" );
		mAdapter1.add("8010000300" );
		mAdapter1.add("8010004000" );
		mAdapter1.add("Mifare 1k card");
		mAdapter1.add("FF82000106FFFFFFFFFFFF" );
		mAdapter1.add("FF860000050100016000" );
		mAdapter1.add("FFB0000210" );
		mAdapter1.add("FFD600021011223344556677889900AABBCCDDEEFF" );
		mAdapter1.add("FFD600021001000000FEFFFFFF0100000001FE01FE" );
		mAdapter1.add("Stress test");
	    mAdapter1.add("007700000004005198ACAA3574C9815E246CBA92328EB4BE9DB925D26A78BCD25B0D052AFF618C43EB41455346C62B798B1528098A493525B0AEC28D893058B783137D23F5E4D8E95FAF9594F4720B3255D29CACA00DDD54A930F7BD878A4ECF5360601A2CE2EF6B7E5E629D84B469B20C0AE0237BC0F67310A68E0A6D6DE541535C75BAAD441AF2D0B6741901738C213724BA15234CC6AC6E7A4D1E42C366360B6F86A87FF3A1A6DC2092AE7099BDA65F8AF32AA19796254A13FD9E0E7319D50402598FAAD6CCAE2A028604DB0D44690BA3530BFC8BAD062CD96635D9654647C57BB81537D4E23242C516C449B76993C3D7A1603C0F55789C344F89AC8135B3D64469E22DD72D5CADD20B96C37F744C108EA7D06A0AD4A3238C81428EAF2E42C0C3349F94C6F352F2902C21504DACBB78302B048C6673AE4849C50988D7781C0A62E3F474887D3C9966430EF8095A098525F6A4AD0A7AC194D3E186A1E15C683C883C88D60713432ABE1604C39BC65DBFD6D057D2DE31068E939D60E1B5224FDF9C0904C12AFD8F2EFF6FACBAEB38E0ADA980C505CADFA2BEEFC33F503B12F87A08100F3ED982472D9014AEE4E2F8BAD707D0974DB6CEC0AC5019CDF75C738B95331A5254FCEB93ADDBCDB14A664D12C5598675B38A4486E11F69AFDDFE8F32B885EE750B7C809C3847645DF260811000056B063D2E8A1CE4C279900A0AAC136C66561F6B3F898A553C9F5CE6B9DADE0F7547F3F58AE8AB3DA3111687691356383E18F87D2E4E858D2248532E57A1A17A0FE2E3E387A55B7528FBE95B010C24A575FDA9483117B4666225EDD0241D84CA3D037F0E0B0B5313BBFEB28EBCDEA53A73CDDAD4312B3F6A62FFD0D60798AC8666746F7EFF60BC9FC3E1192981D3007FA150322A14D34F218B9DA447E7584436F1FB5A3B4CEDBDA1A86DC53337315EFC654D5A51C4570C1245C9122CAEA672624861E94ED8FA7FA2D16A5FB4C841E63A288EFA5127FF9DC5F949C18C43CA5E93D26DC3BE8DCF2A2AA8A08EB51B4BC1C053D9B93327122AC20DE65B6F8E0C3250F7E9909352B3E5BF94D6FB3C189716164CF73FFEABDADD92EB6885DE77B413221F9BFAD50EF0D8EBFDD64E54A76C0EC57DB035BA9A9DDCBCF997E9DFE6092B90B24DA78DABCC2C354B662E02B014D1544CCB4370DEA44FC8A13B2F7DC354A22218C53FC310900925E74F43501BD5864B231210275E375F3E4A1BFFBDF6DDA060BACC6B7D2583964437583645D0F85533694B45E7029E33A75B00FFA967EC4CD3FE29D3C5D2EFFC19A44BAFE9B8C46792863F89B8B220F58B3EB2DA48FFC9CE024DA61EA2FF1A622D97EF5545B983E4F3E2B685A35606CA705AF936A2A4BC4F751009F41D944DF106760BD160BC7BF4DBE578E1AFD699DCE0179DBCC03F0CF7B5AD1BFF3C79D0D12EAA68CA43AAF6BDD4F74C44E51A1E");

		apduListSpinner.setAdapter(mAdapter1);
		apduListSpinner
				.setOnItemSelectedListener(new Spinner.OnItemSelectedListener() {
					@Override
					public void onItemSelected(AdapterView<?> arg0, View arg1,
							int arg2, long arg3) {
						// TODO Auto-generated method stub
						apdu_stirng = list1.get(arg2);
					}

					@Override
					public void onNothingSelected(AdapterView<?> arg0) {
						// TODO Auto-generated method stub
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
					mPowerOn.setEnabled(true);
					displayData("IFD", "card present");
					break;
				case DK.CARD_UNKNOWN:
					displayData("IFD", "card unknown");
					break;
				case DK.IFD_COMMUNICATION_ERROR:
					displayData("IFD", "IFD error");
					break;
				}
				//To monitor reader bluetooth connection status
				//#2, get the reader bluetooth status, add put your handle code here
				case BlueToothReceiver.BLETOOTH_STATUS:
					switch (msg.arg1) {
					
						//Once reader bluetooth connected, then do your operation here
						case BlueToothReceiver.BLETOOTH_CONNECT:
						break;
					case BlueToothReceiver.BLETOOTH_DISCONNECT:
						//Once bluetooth disconnection, change UI
						mReader.readerClose();
						stat_disconnect();
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
			scanLeDevice(true);
			this.mList.setEnabled(false);

		} else if (v == mConnect) {
			new ConnectDevice().execute();			
		} else if (v == mDisConnect) {
			mAdapter.clear();
			list.clear();
			arrayForBlueToothDevice.clear();
			mBlueToothDevice = null;
			mReader.readerClose();
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
				displayData("Send", str);
				new SendAPDU().execute(str);	
			}
		
		} else if (v == mSend1) {
			if (!isLegal(apdu_stirng)) {
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
				displayData("Send", apdu_stirng);
				new SendAPDU().execute(apdu_stirng);	
			}
		} else if (v == mPowerOn) {
			new PowerOn().execute();	
		} else if (v == mPowerOff) {
			new PowerOff().execute();
		} else if (v == BgetHardID) {
			new GetHardID().execute();
		} else if (v == BgenUserID) {
			String str = seedData.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
			} else {
				displayData("GenUID SeedData", str);

				new GenerateUserID().execute(str);
			}
		} else if (v == BgetUserID) {
			new GetUserID().execute();
		} else if (v == BeraseUserID) {
			String str = seedData.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
			} else {
				displayData("EraseUID SeedData", str);
				
				new EraseUserID().execute(str);
			}
		} else if (v == mGetStatus) {
			new GetStatus().execute();
		} else if (v == BGetVersion) {
			new GetVersion().execute();
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
		} else if (v == BReadFlash) {
			int length = 0;
			int offset = 0;
			String str = Eoffset.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
				return;
			}
			offset = (int)(Tool.hexStringToBytes(str)[0] & 0xff);
			str = Elength.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
				return;}
			length = (int)(Tool.hexStringToBytes(str)[0] & 0xff);
			if (offset + length > 255) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage(
								"Illegal address (offset add length should be no greater than 255)")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
			}
			if (length <= 0 || offset < 0) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage(
								"Illegal address (offset should be greater than 0) (offset should be greater than or equal to 0)")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
			}
			EFlash.setText("");
			new ReadFlash().execute(offset , length);
		} else if (v == BWriteFlash) {
			int offset = 0;
			String str = Eoffset.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
				return;
			} else {
				byte[] bytebuf = Tool.hexStringToBytes(str);
				for (int i = 0; i < bytebuf.length; i++)
					offset += bytebuf[i] & 0xff;
			}
			str = EFlash.getText().toString();
			if (!isLegal(str)) {
				new AlertDialog.Builder(BlueTooth.this)
						.setTitle("prompt")
						.setMessage("please input data as '0~9' 'a~f' 'A~F'")
						.setPositiveButton("OK",
								new DialogInterface.OnClickListener() {
									@Override
									public void onClick(DialogInterface dialog,
											int which) {
										seedData.setText("");
									}
								}).show();
			} else {

				byte[] tmp = Tool.hexStringToBytes(str);
				if (offset + tmp.length > 255) {
					new AlertDialog.Builder(BlueTooth.this)
							.setTitle("prompt")
							.setMessage(
									"Illegal address (offset add flash data length should  no greater than than 255)")
							.setPositiveButton("OK",
									new DialogInterface.OnClickListener() {
										@Override
										public void onClick(
												DialogInterface dialog,
												int which) {
											seedData.setText("");
										}
									}).show();
				}
				if (offset < 0) {
					new AlertDialog.Builder(BlueTooth.this)
							.setTitle("prompt")
							.setMessage(
									"Illegal address(offset should be greater than or equal to 0)")
							.setPositiveButton("OK",
									new DialogInterface.OnClickListener() {
										@Override
										public void onClick(DialogInterface dialog,
												int which) {
											seedData.setText("");
										}
									}).show();
				}
				WriteFlashHelp writeFlashHelp = new WriteFlashHelp(str , offset);
				new WriteFlash().execute(writeFlashHelp);
			}
		}
	}

	private void stat_poweroff() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(false);
		mSend.setEnabled(false);
		mSend1.setEnabled(false);
	}

	private void stat_disconnect() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(false);
		mGetStatus.setEnabled(false);
		mSend.setEnabled(false);
		mSend1.setEnabled(false);
		mConnect.setEnabled(true);
		mDisConnect.setEnabled(false);
		BGetVersion.setEnabled(false);
		BWriteFlash.setEnabled(false);
		BReadFlash.setEnabled(false);
		BgetHardID.setEnabled(false);
		BgetUserID.setEnabled(false);
		BeraseUserID.setEnabled(false);
		BgenUserID.setEnabled(false);
	}

	private void stat_poweron() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(true);
		mSend.setEnabled(true);
		mSend1.setEnabled(true);
	}

	private void stat_connect() {
		mPowerOn.setEnabled(false);
		mPowerOff.setEnabled(false);
		mGetStatus.setEnabled(true);
		mSend.setEnabled(false);
		mSend1.setEnabled(false);
		mConnect.setEnabled(false);
		mDisConnect.setEnabled(true);
		BGetVersion.setEnabled(true);
		BWriteFlash.setEnabled(true);
		BReadFlash.setEnabled(true);
		BgetHardID.setEnabled(true);
		BgetUserID.setEnabled(true);
		BeraseUserID.setEnabled(true);
		BgenUserID.setEnabled(true);
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
		
		unregisterReceiver(receiver);
		
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
		if (dataSendStr.length() == 0 || dataSendStr.length() % 2 == 1)
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

	private void scanLeDevice(final boolean enable) {
		if (enable) {
			// Stops scanning after a pre-defined scan period.
			mHandler.postDelayed(new Runnable() {
				@Override
				public void run() {
					mScanning = false;
					mList.setEnabled(true);
					mBluetoothAdapter.stopLeScan(mLeScanCallback);
				}
			}, 10000);

			mScanning = true;
			mList.setEnabled(true);
			mBluetoothAdapter.startLeScan(mLeScanCallback);
		} else {
			mScanning = false;
			mList.setEnabled(true);
			mBluetoothAdapter.stopLeScan(mLeScanCallback);
		}
	}

	private BluetoothAdapter.LeScanCallback mLeScanCallback = new BluetoothAdapter.LeScanCallback() {

		@Override
		public void onLeScan(final BluetoothDevice device, int rssi,
				byte[] scanRecord) {
			runOnUiThread(new Runnable() {
				@Override
				public void run() {
					String str = device.getName();
					if (str == null)
						str = "UnknownDevice";
					if (!arrayForBlueToothDevice.contains(device)
							&& (null != str && (-1 != str.indexOf("FT")))) {
						mAdapter.add(str);
						// displayData("mLeScanCallback" , "device.name = " +
						// str);
						mList.setEnabled(true);
						arrayForBlueToothDevice.add(device);
					}
				}
			});
		}
	};

	class ConnectDevice extends AsyncTask<Void, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}

		protected String doInBackground(Void... params) {

			if (mBlueToothDevice == null) {
				return "select device first";
			}
			try {
				scanLeDevice(false);
				mReader = new ft_reader(mBlueToothDevice.getAddress(), BlueTooth.this);
				mReader.registerCardStatusMonitoring(mHandler);
				return "ok";
			} catch (FtBlueReadException e) {
				return e.toString();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				return "failed";
			}
		}

		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("ok"))
			{
				stat_connect();
				displayData("System", "mConnect ok");
			}
			else
			{
				stat_disconnect();
				displayData("System", result);
			}
		}

	}
	
	class PowerOn extends AsyncTask<Void, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}

		protected String doInBackground(Void... params) {
			try {
				mReader.PowerOn();
				return "success";
			} catch (FtBlueReadException e) {
				return "failed";
			}
		}

		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("success"))
			{
				displayData("PowerON", "success");
				stat_poweron();
			}
			else
			{
				displayData("PowerON", "faild");
			}
		}

	}
	
	class PowerOff extends AsyncTask<Void, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}

		protected String doInBackground(Void... params) {
			try {
				mReader.PowerOff();

				return "success";
			} catch (FtBlueReadException e) {

				return e.toString();
			}
		}

		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("success"))
			{
				displayData("mPowerOff", "success");
				stat_poweroff();
			}
			else
			{
				displayData("mPowerOff", result);
			}
		}

	}

	class SendAPDU extends AsyncTask<String, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}
		@Override
		protected String doInBackground(String... params) {

				byte[] tmp = Tool.hexStringToBytes(params[0]);
				byte[] rev = new byte[Max_Packet_length]; 
				int[] length = new int[2];
				int ret = DK.RETURN_SUCCESS;
				try {
					ret = mReader.transApdu(tmp.length, tmp, length, rev);
					return Tool.byte2HexStr(rev, length[0]);
				} catch (FtBlueReadException e) {
					// TODO Auto-generated catch block
					return e.toString() + "error";
				}
		
		}
		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("error"))
			{
				displayData("Receive", result);
			}
			else
			{
				displayData("Receive", result);
			}
		}

	}
	
	class GetHardID extends AsyncTask<Void, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}
		@Override
		protected String doInBackground(Void... params) {
			int ret = 0;
			byte[] recvBuf = new byte[64];
			int[] recvBufLen = new int[1];
			try {
				ret = mReader.getHardID(recvBuf, recvBufLen);
				
			} catch (FtBlueReadException e) {
				
				return e.toString() + "failed";
			}
			if (ret == DK.RETURN_SUCCESS) {

				return Tool.byte2HexStr(recvBuf, recvBufLen[0]);
				
			} else {

				return "Faile Error " + Integer.toHexString(ret);
			}
		
		}
		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("failed"))
			{
				displayData("getHardID(SerialNum)", result);
			}
			else
			{
				displayData("getHardID(SerialNum)",
						result);
			}
		}

	}
	
	class GenerateUserID extends AsyncTask<String, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}
		@Override
		protected String doInBackground(String... params) {

			byte[] tmp = Tool.hexStringToBytes(params[0]);

			int ret = DK.RETURN_SUCCESS;
			try {
				ret = mReader.genUserID(tmp, tmp.length);
			} catch (FtBlueReadException e) {

				return e.toString();
			}
			if (ret == DK.RETURN_SUCCESS) {

				return "Success";
			} else {

				return "Faile Error " + Integer.toHexString(ret);
			}
		
		}
		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("Success"))
			{
				displayData("genUserID", "Success");
			}
			else
			{
				displayData("genUserID",  result);
			}
		}

	}
	
	class GetUserID extends AsyncTask<Void, Void, String> {

		protected void onPreExecute() {
			pdlg.show();
		}
		@Override
		protected String doInBackground(Void... params) {

			int ret = 0;
			byte[] recvBuf = new byte[64];
			int[] recvBufLen = new int[1];
			try {
				ret = mReader.getUserID(recvBuf, recvBufLen);
			} catch (FtBlueReadException e) {

				return e.toString() + "failed";
			}
			if (ret == DK.RETURN_SUCCESS) {

				return Tool.byte2HexStr(recvBuf, recvBufLen[0]);
			} else {

				return "Faile Error " + Integer.toHexString(ret);
			}
		
		}
		@Override
		protected void onPostExecute(String result) {
			pdlg.hide();
			if (result.endsWith("failed"))
			{
				displayData("getUserID", result);
			}
			else
			{
				displayData("getUserID",  result);
			}
		}

	}
	
		class EraseUserID extends AsyncTask<String, Void, String> {

			protected void onPreExecute() {
				pdlg.show();
			}
			@Override
			protected String doInBackground(String... params) {
				
				byte[] tmp = Tool.hexStringToBytes(params[0]);
				int ret = DK.RETURN_SUCCESS;
				try {
					ret = mReader.earseUserID(tmp, tmp.length);
				} catch (FtBlueReadException e) {

					return e.toString();
				}
				if (ret == DK.RETURN_SUCCESS) {

					return "Success";
				} else {

					return "Faile Error " + Integer.toHexString(ret);
				}
			}
			@Override
			protected void onPostExecute(String result) {
				pdlg.hide();
				if (result.endsWith("Success"))
				{
					displayData("erasUserID", "Success");
				}
				else
				{
					displayData("erasUserID",  result);
				}
			}

		}
		
		class GetStatus extends AsyncTask<Void, Void, String> {

			protected void onPreExecute() {
				pdlg.show();
			}
			@Override
			protected String doInBackground(Void... params) {
				int ret = 0;
				try {
					ret = mReader.getCardStatus();
				} catch (FtBlueReadException e) {

					return e.toString();
				}
				if (ret == DK.CARD_ABSENT) {

					return "card absent";
				} else if (ret == DK.CARD_PRESENT) {
					
					return "card present";
				} else {
					return "card unknow";
				}
			}
			@Override
			protected void onPostExecute(String result) {
				pdlg.hide();
				if (result.endsWith("present"))
				{
					displayData("GetStatus", result);
					mPowerOn.setEnabled(true);
				}
				else
				{
					displayData("GetStatus",  result);
				}
			}

		}
		
		class GetVersion extends AsyncTask<Void, Void, String> {

			protected void onPreExecute() {
				pdlg.show();
			}
			@Override
			protected String doInBackground(Void... params) {
				int ret = 0;
				byte[] recvBuf = new byte[64];
				int[] recvBufLen = new int[1];
				try {
					ret = mReader.getVersion(recvBuf, recvBufLen);
				} catch (FtBlueReadException e) {
					//displayData("getVersion", e.toString());
					return e.toString() + "error";
				}
				if (ret == DK.RETURN_SUCCESS) {
					String verStr = Tool.byte2HexStr(recvBuf, 2);
					//displayData("getVersion", "V" + verStr.substring(0, 2) + "." + verStr.substring(2, 5));
					return "V" + verStr.substring(0, 2) + "." + verStr.substring(2, 5);
				}
				return "error";
			}
			@Override
			protected void onPostExecute(String result) {
				pdlg.hide();
				if (result.endsWith("error"))
				{
					displayData("GetVersion", result);
				
				}
				else
				{
					displayData("GetVersion",  result);
				}
			}

		}
		
		class ReadFlash extends AsyncTask<Integer, Void, String> {

			protected void onPreExecute() {
				pdlg.show();
			}
			@Override
			protected String doInBackground(Integer... params) {
				byte[] recvBuf = new byte[Max_Flash_length];
				int ret ;
				try {
					ret = mReader.readFlash(recvBuf, params[0], params[1]);
				} catch (FtBlueReadException e) {

					return e.toString() + "error";
				}
				if (ret == DK.RETURN_SUCCESS) {

					return Tool.byte2HexStr(recvBuf, params[1]);
				} else {

					return "Faile Error " + Integer.toHexString(ret)  + "error";
				}
			}
			@Override
			protected void onPostExecute(String result) {
				pdlg.hide();
				if (result.endsWith("error"))
				{
					displayData("ReadFlash", result);
				
				}
				else
				{
					displayData("ReadFlash", "Success");
					EFlash.setText(result);
				}
			}

		}
		
		class WriteFlash extends AsyncTask<WriteFlashHelp, Void, String> {

			protected void onPreExecute() {
				pdlg.show();
			}
			@Override
			protected String doInBackground(WriteFlashHelp... params) {
				byte[] tmp = Tool.hexStringToBytes(params[0].writeString);
				int ret;
				try {
					ret = mReader.writeFlash(tmp, params[0].offset, tmp.length);
				} catch (FtBlueReadException e) {

					return e.toString();
				}
				if (ret == DK.RETURN_SUCCESS) {

					return "Success";
				} else {
					
					return "Faile Error " + Integer.toHexString(ret);
				}
			}
			@Override
			protected void onPostExecute(String result) {
				pdlg.hide();
				if (result.endsWith("Success"))
				{
					displayData("WriteFlash", "Success");
				
				}
				else
				{
					displayData("WriteFlash", result);
				}
			}

		}
		class WriteFlashHelp
		{
			String writeString;
			int offset;
			public WriteFlashHelp( String writeString,  int offset)
			{
				this.writeString = writeString;
				this.offset = offset;
			};
		}

}