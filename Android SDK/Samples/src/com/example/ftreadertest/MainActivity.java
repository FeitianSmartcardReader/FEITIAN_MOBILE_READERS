package com.example.ftreadertest;

import java.util.ArrayList;
import java.util.UUID;

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
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.method.ScrollingMovementMethod;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.TextView;
import kawa.lib.thread;

public class MainActivity extends Activity {
	
	final static int PORT = 0x096e;
	
	FTReader ftReader;
	
	ArrayList<BluetoothDevice> arrayForBlueToothDevice = new ArrayList<BluetoothDevice>();
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
	
		findViewById(R.id.button11).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				mHandler.sendMessage(mHandler.obtainMessage(-1, ""));				
			}
		});
		
		findViewById(R.id.buttonA_0).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				ftReader = new FTReader(MainActivity.this,mHandler,DK.FTREADER_TYPE_USB);
				showLog("aaaaaaaaaa");
				use_jar();
			}
		});
		findViewById(R.id.buttonA_11).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerFind();
				} catch (FTException e) {
					showLog("No Device Found---------->" + e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonA_12).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					String[] readerNames;
					readerNames = ftReader.readerOpen(null);					
					updateSpinnerA_14(readerNames);
					
					
					///////////////////////////////////////////////////////////////////////////////////
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
						
						///////////////////////////////////////////////////////////////////////////////////
						///////////////////////////////////////////////////////////////////////////////////
						///////////////////////////////////////////////////////////////////////////////////
						///////////////////////////////////////////////////////////////////////////////////

						
					} catch (Exception e) {
						showLog("GetType Failed------------>"+e.getMessage());
					}
				
					
				} catch (FTException e) {
					showLog("Open Device Failed------------>" + e.getMessage());
					updateSpinnerA_14(new String[0]);
				}

				
				
			}
		});
		findViewById(R.id.buttonA_13).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerClose();
				} catch (FTException e) {
					showLog(e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonA_21).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] atr = ftReader.readerPowerOn(getSpinnerA_14());
					showLog("ATR : "+Utility.bytes2HexStr(atr));
				} catch (Exception e) {
					showLog("Poweron Failed-------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonA_22).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerPowerOff(getSpinnerA_14());
				} catch (Exception e) {
					showLog("PowerOff Failed--------------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonA_23).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerA_14();
					
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
		findViewById(R.id.buttonA_24).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerA_14();
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

		findViewById(R.id.buttonB_0).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler);
				ftReader = pcscServer.getFtReaderObject();
				
				use_native();
			}
		});
		findViewById(R.id.buttonB_11).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					new Tpcsc().testA(PORT);
				} catch (Exception e) {
					showLog("button61 TEST---------->"+e.getMessage());
				}
			}
		});
		
		findViewById(R.id.buttonC_0).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					use_bt3();
					
					final int REQUEST_ENABLE_BT = 1;
					BluetoothAdapter mBlueToothAdapter = null;				
					mBlueToothAdapter = BluetoothAdapter.getDefaultAdapter();
					if(mBlueToothAdapter == null){
						showLog("Doesn't support Bluetooth");
						return;
					}				
					if(! mBlueToothAdapter.isEnabled()){
						startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), REQUEST_ENABLE_BT);
					}
										
					ftReader = new FTReader(MainActivity.this, mHandler, DK.FTREADER_TYPE_BT3);
				} catch (Exception e) {
					e.printStackTrace();
					showLog("EEEEEEEEE----->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonC_11).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					clearSpinnerC_14();;
					arrayForBlueToothDevice.clear();
					ftReader.readerFind();
				} catch (FTException e) {
					showLog("ftReader.readerFind---------->" + e.getMessage());
				}				
			}
		});
		findViewById(R.id.buttonC_12).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerC_14();
					BluetoothDevice device = arrayForBlueToothDevice.get(index);
					showLog("select "+device.getName()+" "+device.getAddress());
					
					if(true){
						device.createBond();
						int times=15;
						while(times-- >0){
							if(device.getBondState() == BluetoothDevice.BOND_BONDED){
								break;
							}else{
								Thread.sleep(1000);
							}
						}
						if(times <= 0){
							new Exception("device bond error");
						}
					}
					
					String[] readerNames = ftReader.readerOpen(device);
					for(int i=0;i<readerNames.length;i++){
						showLog("readerNames["+i+"]:"+readerNames[i]);
					}

					
					
/////////////////////////////////////////////////////////////////////////////////
					
					Thread.sleep(100);
					
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
					}catch (Exception e) {
						showLog("GetType Failed------------>"+e.getMessage());
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
					
				
/////////////////////////////////////////////////////////////////////////////////		
					
					
					
					
					
				} catch (Exception e) {
					showLog("bt3_open -------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonC_13).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerClose();
				} catch (FTException e) {
					showLog("bt3_close -------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonC_21).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] atr = ftReader.readerPowerOn(0);
					showLog("ATR : "+Utility.bytes2HexStr(atr));
				} catch (Exception e) {
					showLog("Poweron Failed-------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonC_22).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerPowerOff(0);
				} catch (Exception e) {
					showLog("PowerOff Failed--------------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonC_23).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					String sendStr = "0084000008";
					showLog("Send:"+sendStr);
					byte[] send = Utility.hexStrToBytes(sendStr);
					byte[] recv = ftReader.readerXfr(0,send);
					showLog("Recv:"+Utility.bytes2HexStr(recv));
				} catch (Exception e) {
					showLog("XFR Failed-------------->"+e.getMessage());
				}
				
			}
		});
		findViewById(R.id.buttonC_24).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int status = ftReader.readerGetSlotStatus(0);
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
		
		findViewById(R.id.buttonD_0).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					use_bt4();
					
					final int REQUEST_ENABLE_BT = 1;
					BluetoothAdapter mBlueToothAdapter = null;				
					mBlueToothAdapter = BluetoothAdapter.getDefaultAdapter();
					if(mBlueToothAdapter == null){
						showLog("²»Ö§³ÖÀ¶ÑÀ");
						return;
					}				
					if(! mBlueToothAdapter.isEnabled()){
						startActivityForResult(new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE), REQUEST_ENABLE_BT);
					}
					
					
					
					ftReader = new FTReader(MainActivity.this, mHandler, DK.FTREADER_TYPE_BT4);
					
				} catch (Exception e) {
					showLog("EEEEEEEEE----->"+e.getMessage());
				}	
			}
		});
		findViewById(R.id.buttonD_11).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					clearSpinnerD_14();;
					arrayForBlueToothDevice.clear();
					ftReader.readerFind();
				} catch (FTException e) {
					showLog("ftReader.readerFind---------->" + e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_12).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int index = getSpinnerD_14();
					BluetoothDevice device = arrayForBlueToothDevice.get(index);
					showLog("select "+device.getName()+" "+device.getAddress());
					
					
					String[] readerNames = ftReader.readerOpen(device);
					for(int i=0;i<readerNames.length;i++){
						showLog("readerNames["+i+"]:"+readerNames[i]);
					}

					Thread.sleep(100);
					
					
/////////////////////////////////////////////////////////////////////////////////
					
					
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
					}catch (Exception e) {
						showLog("GetType Failed------------>"+e.getMessage());
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
					
				
/////////////////////////////////////////////////////////////////////////////////		
					
					
					
					
					
				} catch (Exception e) {
					showLog("bt4_open -------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_13).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerClose();
				} catch (FTException e) {
					showLog("bt4_close -------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_21).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					byte[] atr = ftReader.readerPowerOn(0);
					showLog("ATR : "+Utility.bytes2HexStr(atr));
				} catch (Exception e) {
					showLog("Poweron Failed-------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_22).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					ftReader.readerPowerOff(0);
				} catch (Exception e) {
					showLog("PowerOff Failed--------------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_23).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					String sendStr = "0084000008";
					showLog("Send:"+sendStr);
					byte[] send = Utility.hexStrToBytes(sendStr);
					byte[] recv = ftReader.readerXfr(0,send);
					showLog("Recv:"+Utility.bytes2HexStr(recv));
				} catch (Exception e) {
					showLog("XFR Failed-------------->"+e.getMessage());
				}
			}
		});
		findViewById(R.id.buttonD_24).setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
				try {
					int status = ftReader.readerGetSlotStatus(0);
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
		
		
		
		showLog("LibVersion:"+FTReader.readerGetLibVersion());
		
		
		((TextView) findViewById(R.id.textView)).setMovementMethod(ScrollingMovementMethod.getInstance());
		getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN);
	}

	
	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	private void updateSpinnerA_14(String[] member){
		ArrayAdapter<String> arr_adapter;
		ArrayList<String> arrayList = new ArrayList<String>();
		for(int i=0;i<member.length;i++){
			arrayList.add(member[i]);
		}
		arr_adapter= new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, arrayList);
		((Spinner)findViewById(R.id.spinnerA_14)).setAdapter(arr_adapter);
	}
	
	private int getSpinnerA_14() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinnerA_14)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinner34 Not Selected");
		}
		return index;
	}
	
	private void addSpinnerC_14(String newMumber){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinnerC_14)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}
		arr_adapter.add(newMumber);
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
	
	
	private void addSpinnerD_14(String newMumber){
		ArrayAdapter<String> arr_adapter = (ArrayAdapter<String>)(((Spinner)findViewById(R.id.spinnerD_14)).getAdapter());
		if(arr_adapter == null){
			arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		}
		arr_adapter.add(newMumber);
		((Spinner)findViewById(R.id.spinnerD_14)).setAdapter(arr_adapter);
	}
	private void clearSpinnerD_14(){
		ArrayAdapter<String> arr_adapter = new ArrayAdapter<String>(MainActivity.this, android.R.layout.simple_spinner_item, new ArrayList<String>());
		((Spinner)findViewById(R.id.spinnerD_14)).setAdapter(arr_adapter);
	}
	private int getSpinnerD_14() throws Exception{
		int index = ((Spinner)findViewById(R.id.spinnerD_14)).getSelectedItemPosition();
		if(index < 0){
			throw new Exception("spinnerD_14 Not Selected");
		}
		return index;
	}
	


	private void use_jar(){

		findViewById(R.id.buttonA_0).setEnabled(false);
		findViewById(R.id.buttonB_0).setEnabled(false);
		findViewById(R.id.buttonC_0).setEnabled(false);
		findViewById(R.id.buttonD_0).setEnabled(false);
		
		findViewById(R.id.buttonA_11).setEnabled(true);
		findViewById(R.id.buttonA_12).setEnabled(true);
		findViewById(R.id.buttonA_13).setEnabled(true);		
		findViewById(R.id.buttonA_21).setEnabled(true);
		findViewById(R.id.buttonA_22).setEnabled(true);
		findViewById(R.id.buttonA_23).setEnabled(true);
		findViewById(R.id.buttonA_24).setEnabled(true);
		
		((LinearLayout)findViewById(R.id.layoutB_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_2)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_2)).removeAllViews();

		
	}
	
	private void use_native(){
		findViewById(R.id.buttonA_0).setEnabled(false);
		findViewById(R.id.buttonB_0).setEnabled(false);
		findViewById(R.id.buttonC_0).setEnabled(false);
		findViewById(R.id.buttonD_0).setEnabled(false);
		
		findViewById(R.id.buttonB_11).setEnabled(true);
		
		((LinearLayout)findViewById(R.id.layoutA_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutA_2)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_2)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_2)).removeAllViews();
	}
	
	private void use_bt3(){
		findViewById(R.id.buttonA_0).setEnabled(false);
		findViewById(R.id.buttonB_0).setEnabled(false);
		findViewById(R.id.buttonC_0).setEnabled(false);
		findViewById(R.id.buttonD_0).setEnabled(false);
		
		findViewById(R.id.buttonC_11).setEnabled(true);
		findViewById(R.id.buttonC_12).setEnabled(true);
		findViewById(R.id.buttonC_13).setEnabled(true);
		findViewById(R.id.buttonC_21).setEnabled(true);
		findViewById(R.id.buttonC_22).setEnabled(true);
		findViewById(R.id.buttonC_23).setEnabled(true);
		findViewById(R.id.buttonC_24).setEnabled(true);
		
		((LinearLayout)findViewById(R.id.layoutA_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutA_2)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutB_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutD_2)).removeAllViews();
	}
	
	private void use_bt4(){
		findViewById(R.id.buttonA_0).setEnabled(false);
		findViewById(R.id.buttonB_0).setEnabled(false);
		findViewById(R.id.buttonC_0).setEnabled(false);
		findViewById(R.id.buttonD_0).setEnabled(false);
		
		findViewById(R.id.buttonD_11).setEnabled(true);
		findViewById(R.id.buttonD_12).setEnabled(true);
		findViewById(R.id.buttonD_13).setEnabled(true);
		findViewById(R.id.buttonD_21).setEnabled(true);
		findViewById(R.id.buttonD_22).setEnabled(true);
		findViewById(R.id.buttonD_23).setEnabled(true);
		findViewById(R.id.buttonD_24).setEnabled(true);
		
		((LinearLayout)findViewById(R.id.layoutA_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutA_2)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutB_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_1)).removeAllViews();
		((LinearLayout)findViewById(R.id.layoutC_2)).removeAllViews();
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
				break;				
			case DK.USB_IN:
				textView.append("¡¾NOTICE¡¿------->USB Device In\n");
				try {
					ftReader.readerFind();
				} catch (Exception e) {
					textView.append("¡¾NOTICE¡¿------->USB Device In------->this should not happend------>" + e.getMessage() + "\n");
				}				
				return;
			case DK.USB_OUT:
				textView.append("¡¾NOTICE¡¿------->USB Device Out\n");
				updateSpinnerA_14(new String[0]);
				return;
			case DK.PCSCSERVER_LOG:
				textView.append("[PcscServerLog]:"+msg.obj+"\n");
				return;
			case DK.BT3_NEW:
				BluetoothDevice device = (BluetoothDevice) msg.obj;
				textView.append("[BT3_NEW]:"+device.getName()+"\n");
				if(device.getName()!=null && device.getName().startsWith("FT_")){
					arrayForBlueToothDevice.add(device);					
					addSpinnerC_14("¡¾"+device.getName()+"¡¿"+device.getAddress());
				}
				return;
			case DK.BT4_NEW:
				BluetoothDevice mDevice = (BluetoothDevice) msg.obj;
				textView.append("[BT4_NEW]:"+mDevice.getName()+"\n");
				if(mDevice.getName()!=null && mDevice.getName().startsWith("FT_")){
					arrayForBlueToothDevice.add(mDevice);					
					addSpinnerD_14("["+mDevice.getName()+"]"+mDevice.getAddress());
				}
				return;
			default:
				if((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK){
					textView.append("¡¾NOTICE¡¿------->" + "slot"+(msg.what%DK.CARD_IN_MASK)+":card in\n");
					return;
				}else if((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK){
					textView.append("¡¾NOTICE¡¿------->" + "slot"+(msg.what%DK.CARD_OUT_MASK)+":card out\n");
					return;
				}
				
				break;
			}
			if(log == null){
				textView.append("[OBJ]---------->"+"what:"+msg.what+"   obj:"+msg.obj+"\n");				
			}else{
				textView.append("¡¾LOG¡¿---------->"+log+"\n");
			}
			
		}
	};
	
	private void showLog(String log){
		mHandler.sendMessage(mHandler.obtainMessage(0, log));
	}
}
