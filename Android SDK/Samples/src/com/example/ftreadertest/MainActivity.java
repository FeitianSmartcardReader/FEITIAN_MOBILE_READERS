package com.example.ftreadertest;

import java.util.ArrayList;
import java.util.UUID;

import com.example.ftreadertest.R;
import com.ftsafe.DK;
import com.ftsafe.PcscServer;
import com.ftsafe.Utility;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothAdapter.LeScanCallback;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.bluetooth.le.BluetoothLeScanner;
import android.bluetooth.le.ScanCallback;
import android.content.Intent;
import android.net.NetworkInfo.DetailedState;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.method.ScrollingMovementMethod;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import kawa.lib.case_syntax;
import kawa.lib.thread;
import kawa.standard.try_catch;

public class MainActivity extends Activity {
	
	final static int PORT = 0x096e;
	private static final String TextView = null;
	private static final String Button = null;
	
	private boolean ifJni = false;
	private boolean ifJar = false;
	private boolean ifUsb = false;
	FTReader ftReader = null;
	Tpcsc tpcsc = null;
	ArrayList<BluetoothDevice> arrayForBlueToothDevice = new ArrayList<BluetoothDevice>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		findViewById(R.id.clear).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				mHandler.sendMessage(mHandler.obtainMessage(-1, ""));				
			}
		});
		
		findViewById(R.id.exit).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				finish();				
			}
		});
		
		findViewById(R.id.jni).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				setJniAndJar(true, false);
				displayJniView(true);
				tpcsc = new Tpcsc(PORT);
				showLog(" You are using PC/SC API with C lib");
				disabelArea1();
			}
		});
		
		findViewById(R.id.jar).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				setJniAndJar(false, true);
				displayJarUsbView(true);
				tpcsc = new Tpcsc(PORT);
				showLog("You are using Private API with Jar lib");
				disabelArea1();
			}
		});

		findViewById(R.id.USBMODE).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_USB,DK.FTREADER_JNI);
					//do this then you will not receive detailed debug information
					pcscServer.ifDebug(true);
					showLog("now is in use mode,check whether the smartcard reader has been inserted");
					ifUsb = true;
					disabelArea2();
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_USB,DK.FTREADER_JAR);
					showLog("now is in use mode,check whether the smartcard reader has been inserted");
					ifUsb = true;
					disabelArea2();
				}else{
					showLog("you should choose jni or jar mode");
				}				
			}
		});
		
		findViewById(R.id.BTMODE).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_BT3,DK.FTREADER_JNI);
					//do this then you will not receive detailed debug information
					pcscServer.ifDebug(true);
					showLog("now is in bluetooth mode,check whether the smartcard reader has been bound");
					ifUsb = false;
					disabelArea2();
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_BT3,DK.FTREADER_JAR);
					showLog("now is in bluetooth mode,check whether the smartcard reader has been bound");
					ifUsb = false;
					disabelArea2();
				}else{
					showLog("you should choose jni or jar mode");
				}
			}
		});
		
		findViewById(R.id.BLEMODE).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_BT4,DK.FTREADER_JNI);
					//do this then you will not receive detailed debug information
					pcscServer.ifDebug(true);
					showLog("now is in ble mode,check whether the smartcard reader has been opened");
					ifUsb = false;
					disabelArea2();
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_BT4,DK.FTREADER_JAR);
					showLog("now is in ble mode,check whether the smartcard reader has been opened");
					ifUsb = false;
					disabelArea2();
				}else{
					showLog("you should choose jni or jar mode");
				}
			}
		});
		
		findViewById(R.id.button21).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int ret = tpcsc.SCardEstablishContext();
				if(0 == ret){
					showLog("SCardEstablishContext OK");
				}else{
					showLog("SCardEstablishContext Error");
				}
			}
		});
		
		findViewById(R.id.button22).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				String readers = tpcsc.SCardListReaders();
				String[] devNameArray = readers.split(":");
				addSpinnerC_14(devNameArray);
				showLog("SCardListReaders: " + readers);
			}
		});
		
		findViewById(R.id.button31).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
					int index;
					try {
						index = getSpinnerC_14();
						int ret = tpcsc.SCardConnect(index);
						if(0 == ret){
							showLog("SCardConnect OK");
						}else{
							showLog("SCardConnect Error");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
		});
		findViewById(R.id.button32).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				byte[] sCardStatus = tpcsc.SCardStatus();
				showLog("ATR: " + Utility.bytes2HexStr(sCardStatus));
			}
		});

		findViewById(R.id.button33).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int ret = tpcsc.SCardDisconnect();
				if(0 == ret){
					showLog("SCardDisconnect OK");
				}else{
					showLog("SCardDisconnect Error");
				}
			}
		});
		
		findViewById(R.id.button34).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int ret = tpcsc.SCardReleaseContext();
				if(0 == ret){
					showLog("SCardReleaseContext OK");
				}else{
					showLog("SCardReleaseContext Error");
				}
			}
		});
		
		findViewById(R.id.button41).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] apduByte = Utility.hexStrToBytes(getApdu());
					byte[] ret = tpcsc.SCardTransmit(apduByte, apduByte.length);
					showLog("apdu: " + Utility.bytes2HexStr(ret));
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		});
		
		
		findViewById(R.id.ft_find).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					arrayForBlueToothDevice.clear();
					ftReader.readerFind();
				} catch (FTException e) {
					showLog("No Device Found---------->" + e.getMessage());
				}
				if(ifUsb){
					showLog("Device Found Ok  you need goto 'ft_open'");
				}
			}
		});
		
		findViewById(R.id.ft_open).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				String[] readerNames;
				try {
					if(ifUsb){
						readerNames = ftReader.readerOpen(null);
						addSpinnerJar(readerNames);
					}else{
						int index = getSpinnerJar();
						BluetoothDevice device = arrayForBlueToothDevice.get(index);
						readerNames = ftReader.readerOpen(device);
						for(int i=0;i<readerNames.length;i++){
							showLog("readerNames["+i+"]:"+readerNames[i]);
						}
					}
				}catch (Exception e) {
					showLog("Open Device Failed------------>" + e.getMessage());
				}	
			}
		});
		
		
		findViewById(R.id.ft_close).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerClose();
				} catch (FTException e) {
					showLog(e.getMessage());
				}
			}
		});
		
		
		findViewById(R.id.ft_poweron).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] atr = ftReader.readerPowerOn(getSpinnerJar());
					showLog("ATR : "+Utility.bytes2HexStr(atr));
				} catch (Exception e) {
					showLog("Poweron Failed------------>"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.ft_poweroff).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerPowerOff(getSpinnerJar());
				} catch (Exception e) {
					showLog("PowerOff Failed------------>"+e.getMessage());
				}
			}
		});
		
		
		findViewById(R.id.ft_xfr).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerJar();
					String sendStr = "0084000008";
					showLog("Send:"+sendStr);
					byte[] send = Utility.hexStrToBytes(sendStr);
					byte[] recv = ftReader.readerXfr(index,send);
					showLog("Recv:"+Utility.bytes2HexStr(recv));
				} catch (Exception e) {
					showLog("XFR Failed-------------->"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.slotStatus).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerJar();
					int status = ftReader.readerGetSlotStatus(index);
					switch (status) {
					case DK.CARD_PRESENT_ACTIVE:
						showLog("SlotStatus: card present and powered");
						break;
					case DK.CARD_PRESENT_INACTIVE:
						showLog("SlotStatus: card present and no powered");
						break;
					case DK.CARD_NO_PRESENT:
						showLog("SlotStatus: card no present");
						break;
					}
				} catch (Exception e) {
					showLog("GetSlotStatus failed---------->"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.readerInfo).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				
				showLog("LibVersion:"+FTReader.readerGetLibVersion());
				
				try {
					int type = ftReader.readerGetType();					
					switch (type) {
					case DK.READER_R301E:
						showLog("ReaderType:R301E");
						break;
					case DK.READER_BR301FC4:
						showLog("ReaderType:BR301FC4");
						break;
					case DK.READER_BR500:
						showLog("ReaderType:Br500");
						break;
					case DK.READER_R502_CL:
						showLog("ReaderType:R502-CL");
						break;
					case DK.READER_R502_DUAL:
						showLog("ReaderType:R502-Dual");
						break;
					case DK.READER_BR301:
						showLog("ReaderType:bR301");
						break;
					case DK.READER_IR301_LT:
						showLog("ReaderType:iR301-LT");
						break;
					case DK.READER_IR301:
						showLog("ReaderType:iR301");
						break;
					case DK.READER_VR504:
						showLog("ReaderType:VR504");
						break;
					default:
						showLog("ReaderType:Unknow");
						break;
					}
				} catch (Exception e) {
					showLog("GetType Failed------------>"+e.getMessage());
				}
				////////////////////////////////////////////////////////////////////////
				try{
					byte[] manufacturer = ftReader.readerGetManufacturer();
					showLog("Manufacturer:" + new String(manufacturer)/*Utility.bytes2HexStr(manufacturer)*/);
				}catch(Exception e){
					showLog("GetManufacturer Failed--------------->"+e.getMessage());
				}
				/////////////////////////////////////////////////////////////////////////
				try{
					byte[] hardwareInfo = ftReader.readerGetHardwareInfo();
					showLog("HardwareInfo:" + Utility.bytes2HexStr(hardwareInfo));
				}catch(Exception e){
					showLog("HardwareInfo Failed--------------->"+e.getMessage());
				}
				/////////////////////////////////////////////////////////////////////
				try{
					byte[] readerName = ftReader.readerGetReaderName();
					showLog("ReaderName:" + new String(readerName));
				}catch(Exception e){
					showLog("ReaderName Failed--------------->"+e.getMessage());
				}

				///////////////////////////////////////////////////////////////////////////////////
					try {
						byte[] serial = ftReader.readerGetSerialNumber();
						showLog("SerialNumber:"+Utility.bytes2HexStr(serial));
					} catch (Exception e) {
						showLog("GetSerialNum ERROR----->"+e.getMessage());
					}
					///////////////////////////////////////////////////////////////////////////////////
					try {
						
						String ver = ftReader.readerGetFirmwareVersion();
						showLog("FirmwareVerson:"+ver);					
					} catch (Exception e) {
						showLog("GetFirmwareVersion Failed------->"+e.getMessage());
					}
					///////////////////////////////////////////////////////////////////////////////////
					try {
						byte[] uid = ftReader.readerGetUID();
						showLog("UID:"+Utility.bytes2HexStr(uid));
					} catch (Exception e) {
						showLog("GetUID Failed--------------->"+e.getMessage());
					}
					
					
					
					
				
				
			}
		});
	
		
		
		((TextView) findViewById(R.id.textView)).setMovementMethod(ScrollingMovementMethod.getInstance());
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
	}
	
	
	

	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private void addSpinnerJar(String[] devNameArray){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinner_jar)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}else{
			arr_adapter.clear();
		}
		for (String devName : devNameArray) {
			arr_adapter.add(devName);
		}
		((Spinner)findViewById(R.id.spinner_jar)).setAdapter(arr_adapter);
	}
	
	
	private int getSpinnerJar() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinner_jar)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinner_usb Not Selected");
		}
		return index;
	}
	
	private void addSpinnerJar(String devName){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinner_jar)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}
		arr_adapter.add(devName);
		((Spinner)findViewById(R.id.spinner_jar)).setAdapter(arr_adapter);
	}
	
	
	
	private void addSpinnerC_14(String[] devNameArray){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinnerC_14)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}else{
			arr_adapter.clear();
		}
		for (String devName : devNameArray) {
			arr_adapter.add(devName);
		}
		((Spinner)findViewById(R.id.spinnerC_14)).setAdapter(arr_adapter);
	}
	
	
	
	private void clearSpinnerC_14(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());		
		((Spinner)findViewById(R.id.spinnerC_14)).setAdapter(arr_adapter);
	}
	
	private int getSpinnerC_14() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinnerC_14)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinnerC_14 Not Selected");
		}
		return index;
	}
	
	
	private String getApdu(){
		EditText apduEdit = (EditText)findViewById(R.id.apdu);
		return apduEdit.getText().toString();
	}
	
	
	

	
	private Handler mHandler = new Handler(){
		@Override
		public void handleMessage(Message msg){
			super.handleMessage(msg);
			TextView textView = (TextView) findViewById(R.id.textView);
			
			String log=null;
			
			switch (msg.what) {
			case -1:
				textView.setText("");
				return;
			case 0:
				log = msg.obj.toString();
				textView.append("LOG---------->"+log+"\n");
				break;				
			case DK.USB_IN:
				textView.append("NOTICE------->USB Device In\n");
				/*try {
					ftReader.readerFind();
				} catch (Exception e) {
					textView.append("NOTICE------->USB Device In------->this should not happend------>" + e.getMessage() + "\n");
				}*/				
				break;
			case DK.USB_OUT:
				textView.append("NOTICE------->USB Device Out\n");
				break;
			case DK.PCSCSERVER_LOG:
				textView.append("[PcscServerLog]:"+msg.obj+"\n");
				break;
			
			case DK.BT3_NEW:
				BluetoothDevice dev1 = (BluetoothDevice) msg.obj;
				textView.append("[BT3_NEW]:"+dev1.getName()+"\n");
				arrayForBlueToothDevice.add(dev1);
				addSpinnerJar(dev1.getName());
				break;
		
			case DK.BT4_NEW:
				BluetoothDevice dev2 = (BluetoothDevice) msg.obj;
				textView.append("[BT4_NEW]:"+dev2.getName()+"\n");
				arrayForBlueToothDevice.add(dev2);
				addSpinnerJar(dev2.getName());
				break;
				
			default:
				if((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK){
					textView.append("NOTICE------->" + "slot"+(msg.what%DK.CARD_IN_MASK)+":card in\n");
					return;
				}else if((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK){
					textView.append("NOTICE------->" + "slot"+(msg.what%DK.CARD_OUT_MASK)+":card out\n");
					return;
				}
				break;
			}
		}
	};
	private View findViewById;
	
	private void showLog(String log){
		mHandler.sendMessage(mHandler.obtainMessage(0, log));
	}
	
	
	////////////
	private void setJniAndJar(boolean jni,boolean jar){
		this.ifJni = jni;
		this.ifJar = jar;
	} 
	  
	private boolean getifJni(){
		return this.ifJni;
	}
	
	private boolean getifJar(){
		return this.ifJar;
	}
	
	///////////////////////////////////view operate
	public void displayJniView(boolean visible){
		if(visible){
			findViewById(R.id.jar_area).setVisibility(View.GONE);
			findViewById(R.id.pcsc_area).setVisibility(View.VISIBLE);
		}else{
			findViewById(R.id.pcsc_area).setVisibility(View.GONE);
		}
	}
	
	public void displayJarUsbView(boolean visible){
		if(visible){
			findViewById(R.id.pcsc_area).setVisibility(View.GONE);
			findViewById(R.id.jar_area).setVisibility(View.VISIBLE);
		}else{
			findViewById(R.id.jar_area).setVisibility(View.GONE);
		}
	}
	
	public void  disabelArea1(){
		findViewById(R.id.jar).setEnabled(false);
		findViewById(R.id.jni).setEnabled(false);
	}
	
	public void  disabelArea2(){
		findViewById(R.id.USBMODE).setEnabled(false);
		findViewById(R.id.BTMODE).setEnabled(false);
		findViewById(R.id.BLEMODE).setEnabled(false);
	}
	
	
	
}
