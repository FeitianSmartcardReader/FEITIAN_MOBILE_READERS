package com.example.ftReaderStandard;

import java.util.ArrayList;
import java.util.UUID;

import com.example.ftReaderStandard.R;
import com.example.ftReaderStandard.Tpcsc;
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
import android.content.pm.ActivityInfo;
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
		
		setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		
		showLog("LibVersion:"+FTReader.readerGetLibVersion());
		
///////////////////////////////////////add spinner///////////////////////////////////////
		
	    ((Spinner)findViewById(R.id.spinner_PCSC_APDU)).setAdapter(getTestCmd());
	    ((Spinner)findViewById(R.id.spinner_Private_APDU)).setAdapter(getTestCmd());
	    ((Spinner)findViewById(R.id.spinner_AutoTurnOffSelect)).setAdapter(getAutoTurnOffSelect());
		
		
///////////////////////////////////////add spinner end///////////////////////////////////////
		findViewById(R.id.button_clear).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				mHandler.sendMessage(mHandler.obtainMessage(-1, ""));				
			}
		});
		
		findViewById(R.id.button_exit).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				android.os.Process.killProcess(android.os.Process.myPid());
				// finish();
			}
		});
		
		findViewById(R.id.button_use_jni).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				setJniAndJar(true, false);
				//displayJniView(true);
				tpcsc = new Tpcsc(PORT);
				showLog(" You are using PC/SC API with C lib");
				disabelArea1();
			}
		});
		
		findViewById(R.id.button_use_jar).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				setJniAndJar(false, true);
				//displayJarUsbView(true);
				tpcsc = new Tpcsc(PORT);
				showLog("You are using Private API with Jar lib");
				disabelArea1();
			}
		});

		findViewById(R.id.button_mode_usb).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_USB);
					//do this then you will not receive detailed debug information
					showLog("now is in usb mode,check whether the smartcard reader has been inserted");
					ifUsb = true;
					disabelArea2();
					displayJniView(true);
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_USB);
					showLog("now is in usb mode,check whether the smartcard reader has been inserted");
					ifUsb = true;
					disabelArea2();
					displayJarUsbView(true);
				}else{
					showLog("you should choose jni or jar mode");
				}				
			}
		});
		
		findViewById(R.id.button_mode_bt3).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_BT3);
					//do this then you will not receive detailed debug information
					showLog("now is in bluetooth mode,check whether the smartcard reader has been bound");
					ifUsb = false;
					disabelArea2();
					displayJniView(true);
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_BT3);
					showLog("now is in bluetooth mode,check whether the smartcard reader has been bound");
					ifUsb = false;
					disabelArea2();
					displayJarUsbView(true);
				}else{
					showLog("you should choose jni or jar mode");
				}
			}
		});
		
		findViewById(R.id.button_mode_bt4).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				if(getifJni()){
					PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler,DK.FTREADER_TYPE_BT4);
					//do this then you will not receive detailed debug information
					showLog("now is in ble mode,check whether the smartcard reader has been opened");
					ifUsb = false;
					disabelArea2();
					displayJniView(true);
				}else if(getifJar()){
					ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_BT4);
					showLog("now is in ble mode,check whether the smartcard reader has been opened");
					ifUsb = false;
					disabelArea2();
					displayJarUsbView(true);
				}else{
					showLog("you should choose jni or jar mode");
				}
			}
		});
		
		findViewById(R.id.button_SCardEstablishContext).setOnClickListener(new OnClickListener() {
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
		
		findViewById(R.id.button_SCardListReaders).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				clearSpinnerPCSC();
				String readers = tpcsc.SCardListReaders();
				String[] devNameArray = readers.split(":");
				addSpinnerPCSC(devNameArray);
				showLog("SCardListReaders: " + readers);
			}
		});
		
		findViewById(R.id.button_SCardConnect).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
					int index;
					try {
						index = getSpinnerPCSC();
						int ret = tpcsc.SCardConnect(index);
						if(0 == ret){
							showLog("SCardConnect ["+((Spinner)findViewById(R.id.spinner_PCSC)).getSelectedItem().toString()+"] OK");
							
							Thread.sleep(100);
							int status = tpcsc.SCardGetStatusChange(index);
							if(status == 32) {
								showLog("[first]slot0:card in");
							}else {
								showLog("[first]slot0:card out");
							}
						}else if(1 == ret) {
							showLog("SCardConnect OK : reader connect & power on error");
						}else{
							showLog("SCardConnect Error");
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
		});
		findViewById(R.id.button_SCardStatus).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				byte[] sCardStatus = tpcsc.SCardStatus();
				showLog("ATR: " + Utility.bytes2HexStr(sCardStatus));
				try {
					Thread.sleep(100);
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		});

		findViewById(R.id.button_SCardDisconnect).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int ret = tpcsc.SCardDisconnect();
				if(0 == ret){
					showLog("SCardDisconnect OK");
					arrayForBlueToothDevice.clear();
				}else{
					showLog("SCardDisconnect Error");
				}
			}
		});
		
		findViewById(R.id.button_SCardReleaseContext).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				
				tpcsc.SCardDisconnect();
				
				int ret = tpcsc.SCardReleaseContext();
				if(0 == ret){
					showLog("SCardReleaseContext OK");
				}else{
					showLog("SCardReleaseContext Error");
				}
			}
		});
		
		findViewById(R.id.button_SCardTransmit).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] apduByte = Utility.hexStrToBytes(getPCSCEditTextApdu());
					byte[] ret = tpcsc.SCardTransmit(apduByte, apduByte.length);
					if(ret.length == 0) {
						showLog("apdu error [errorMessage] "+tpcsc.SCardGetLastError());
					}else {
						showLog("apdu: " + Utility.bytes2HexStr(ret));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		
		findViewById(R.id.button_SCardTransmit2).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] apduByte = Utility.hexStrToBytes(getSpinnerPCSCAPDU());
					byte[] ret = tpcsc.SCardTransmit(apduByte, apduByte.length);
					if(ret.length == 0) {
						showLog("apdu error [errorMessage] "+tpcsc.SCardGetLastError());
					}else {
						showLog("apdu: " + Utility.bytes2HexStr(ret));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		});
		
		findViewById(R.id.button_SCardControl).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] apduByte = Utility.hexStrToBytes(getPCSCEditTextCtl());
					byte[] ret = tpcsc.SCardControl(apduByte, apduByte.length);
					if(ret.length == 0) {
						showLog("apdu error [errorMessage] "+tpcsc.SCardGetLastError());
					}else {
						showLog("apdu: " + Utility.bytes2HexStr(ret));
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
		
		findViewById(R.id.button_SCardIsValidContext).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int ret = tpcsc.SCardIsValidContext();
				if(0 == ret){
					showLog("SCardIsValidContext OK");
				}else{
					showLog("SCardIsValidContext Error");
				}
			}
		});
		
		findViewById(R.id.button_SCardGetStatusChange).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				int index;
				try {
					index = getSpinnerPCSC();
					int ret = tpcsc.SCardGetStatusChange(index);
					showLog("SCardGetStatusChange "+ret);
					
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			}
		});
		
		findViewById(R.id.button_readerFind).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					arrayForBlueToothDevice.clear();
					clearSpinnerPrivate();
					ftReader.readerFind();
				} catch (FTException e) {
					showLog("No Device Found---------->" + e.getMessage());
				}
				if(ifUsb){
					showLog("Device Found Ok  you need goto 'ft_open'");
				}
			}
		});
		
		findViewById(R.id.button_readerOpen).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				String[] readerNames;
				try {
					if(ifUsb){
						readerNames = ftReader.readerOpen(null);
						clearSpinnerPrivate();
						addSpinnerPrivate(readerNames);
					}else{
						int index = getSpinnerPrivate();
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
		
		
		findViewById(R.id.button_readerClose).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerClose();
				} catch (FTException e) {
					showLog(e.getMessage());
				}
			}
		});
		
		
		findViewById(R.id.button_readerPowerOn).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] atr = ftReader.readerPowerOn((ifUsb)?getSpinnerPrivate():0);
					showLog("ATR : "+Utility.bytes2HexStr(atr));
				} catch (Exception e) {
					showLog("Poweron Failed------------>"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.button_readerPowerOff).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerPowerOff((ifUsb)?getSpinnerPrivate():0);
				} catch (Exception e) {
					showLog("PowerOff Failed------------>"+e.getMessage());
				}
			}
		});
		
		
		findViewById(R.id.button_readerXfr).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = (ifUsb)?getSpinnerPrivate():0;
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
		
		findViewById(R.id.button_readerGetSlotStatus).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = (ifUsb)?getSpinnerPrivate():0;
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
		
		findViewById(R.id.button_readerGetType).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				
				
				if(ifUsb) {
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
							showLog("ReaderType:bR500");
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
				}else {
					showLog("ReaderType not support");
				}
				////////////////////////////////////////////////////////////////////////
				try{
					byte[] manufacturer = ftReader.readerGetManufacturer();
					showLog("Manufacturer:" + new String(manufacturer)/*Utility.bytes2HexStr(manufacturer)*/);
				}catch(Exception e){
					showLog("GetManufacturer not support");
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
						if(ifUsb) {
							String ver = ftReader.readerGetFirmwareVersion();
							showLog("FirmwareVersion:"+ver);	
						}else {
							showLog("FirmwareVersion not support");	
						}
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
	
		
		findViewById(R.id.button_readerAutoTurnOff).setOnClickListener(new OnClickListener(){
			@Override
			public void onClick(View v) {
				try{
					int index = getSpinnerAutoTurnOff();
					if(0 == index){
						byte[] recv = ftReader.FT_AutoTurnOffReader(true);
						showLog("Recv:"+Utility.bytes2HexStr(recv));
					}else if(1 == index){
						byte[] recv = ftReader.FT_AutoTurnOffReader(false);
						showLog("Recv:"+Utility.bytes2HexStr(recv));
					}
				}catch(Exception e){
					showLog("AutoTurnOff-------------->"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.button_readerXfr2).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = (ifUsb)?getSpinnerPrivate():0;
					String sendStr = getSpinnerPrivateAPDU();
					showLog("Send:"+sendStr);
					byte[] send = Utility.hexStrToBytes(sendStr);
					byte[] recv = ftReader.readerXfr(index,send);
					showLog("Recv:"+Utility.bytes2HexStr(recv));
				} catch (Exception e) {
					showLog("XFR Failed-------------->"+e.getMessage());
				}
			}
		});
		
		((TextView) findViewById(R.id.textView)).setMovementMethod(ScrollingMovementMethod.getInstance());
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
	}
	
	
	

	@Override
	protected void onPause() {
		//android.os.Process.killProcess(android.os.Process.myPid());
		super.onPause();
	}
	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	private void addSpinnerPrivate(String devName){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinner_Private)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}
		arr_adapter.add(devName);
		((Spinner)findViewById(R.id.spinner_Private)).setAdapter(arr_adapter);
	}
	
	private void addSpinnerPrivate(String[] devNameArray){
		for (String devName : devNameArray) {
			addSpinnerPrivate(devName);
		}
	}
	
	private int getSpinnerAutoTurnOff() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinner_AutoTurnOffSelect)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinner_AutoTurnOffSelect Not Selected");
		}
		return index;
	}
	
	private int getSpinnerPrivate() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinner_Private)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinner_usb Not Selected");
		}
		return index;
	}

	private void clearSpinnerPrivate(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());		
		((Spinner)findViewById(R.id.spinner_Private)).setAdapter(arr_adapter);
	}
	
	private void addSpinnerPCSC(String[] devNameArray){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinner_PCSC)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}else{
			arr_adapter.clear();
		}
		for (String devName : devNameArray) {
			arr_adapter.add(devName);
		}
		((Spinner)findViewById(R.id.spinner_PCSC)).setAdapter(arr_adapter);
	}
	
	private void clearSpinnerPCSC(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());		
		((Spinner)findViewById(R.id.spinner_PCSC)).setAdapter(arr_adapter);
	}
	
	private int getSpinnerPCSC() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinner_PCSC)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinnerC_14 Not Selected");
		}
		return index;
	}
	
	private String getPCSCEditTextApdu(){
		EditText apduEdit = (EditText)findViewById(R.id.edittext_PCSC_APDU);
		return apduEdit.getText().toString();
	}
	
	private String getSpinnerPCSCAPDU() {
		return ((Spinner)findViewById(R.id.spinner_PCSC_APDU)).getSelectedItem().toString();
	}
	
	private String getPCSCEditTextCtl(){
		EditText apduEdit = (EditText)findViewById(R.id.edittext_PCSC_CTL);
		return apduEdit.getText().toString();
	}
	
	private String getSpinnerPrivateAPDU() {
		return ((Spinner)findViewById(R.id.spinner_Private_APDU)).getSelectedItem().toString();
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
				//textView.append("[PcscServerLog]:"+msg.obj+"\n");
				break;
			case DK.USB_LOG:
				//textView.append("[USBLog]:"+msg.obj+"\n");
				break;
			case DK.BT3_LOG:
				//textView.append("[BT3Log]:"+msg.obj+"\n");
				break;
			case DK.BT4_LOG:
				//textView.append("[BT4Log]:"+msg.obj+"\n");
				break;
			case DK.FTREADER_LOG:
				//textView.append("[FTReaderLog]:"+msg.obj+"\n");
				break;
			case DK.CCIDSCHEME_LOG:
				//textView.append("[CCIDSchemeLog]:"+msg.obj+"\n");
				break;
			case DK.BT3_NEW:
				BluetoothDevice dev1 = (BluetoothDevice) msg.obj;
				textView.append("[BT3_NEW]:"+dev1.getName()+"\n");
				arrayForBlueToothDevice.add(dev1);
				addSpinnerPrivate(dev1.getName());
				break;
		
			case DK.BT4_NEW:
				BluetoothDevice dev2 = (BluetoothDevice) msg.obj;
				textView.append("[BT4_NEW]:"+dev2.getName()+"\n");
				arrayForBlueToothDevice.add(dev2);
				addSpinnerPrivate(dev2.getName());
				break;
			case DK.BT4_ACL_DISCONNECTED:
				BluetoothDevice dev3 = (BluetoothDevice) msg.obj;
				textView.append("[BT4_ACL_DISCONNECTED]: "+dev3.getName()+" disconnected\n");
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
		findViewById(R.id.button_use_jar).setEnabled(false);
		findViewById(R.id.button_use_jni).setEnabled(false);
	}
	
	public void  disabelArea2(){
		findViewById(R.id.button_mode_usb).setEnabled(false);
		findViewById(R.id.button_mode_bt3).setEnabled(false);
		findViewById(R.id.button_mode_bt4).setEnabled(false);
	}
	
	public ArrayAdapter<String> getAutoTurnOffSelect(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());		
		arr_adapter.add("true");
		arr_adapter.add("false");
		return arr_adapter;
	}
	
	public ArrayAdapter<String> getTestCmd(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());		
		arr_adapter.add("0084000008");
		arr_adapter.add("java card command as follow:");
		arr_adapter.add("008400007F");
		arr_adapter.add("00A4040008D156000001010301");
		arr_adapter.add("00A40000023F00");
		arr_adapter.add("00e4010002a001");
		arr_adapter.add("00e00000186216820238008302a00185020000860800000000000000ff");
		arr_adapter.add("00A4000002A001");
		arr_adapter.add("00E00000186216820201018302B001850200ff86080000000000000000");
		arr_adapter.add("00D60000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849");
		arr_adapter.add("00D60000FB0001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950");
		arr_adapter.add("00D60000FF000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061626364656667686970717273747576777879808182838485868788899091929394959697989900010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354");
		arr_adapter.add("00b00000FF");
		arr_adapter.add("00A40000023F00");
		arr_adapter.add("00A4000002A001");
		arr_adapter.add("00e4020002B001");
		arr_adapter.add("00A40000023F00");
		arr_adapter.add("00e4010002a001");
	    return arr_adapter;
	}
	
}
