package com.example.ftReaderStandard;

import android.bluetooth.BluetoothDevice;
import android.content.pm.ActivityInfo;
import android.os.Handler;
import android.os.Message;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.WindowManager;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.view.View;
import android.view.View.OnClickListener;

import com.ftsafe.DK;
import com.ftsafe.PcscServer;
import com.ftsafe.Utility;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

import java.util.ArrayList;

//public class MainActivity extends AppCompatActivity {
//
//    // Used to load the 'native-lib' library on application startup.
//    static {
//        System.loadLibrary("native-lib");
//    }
//
//    @Override
//    protected void onCreate(Bundle savedInstanceState) {
//        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_main);
//
//        // Example of a call to a native method
//        TextView tv = (TextView) findViewById(R.id.textView);
//        tv.setText(stringFromJNI());
//    }
//
//    /**
//     * A native method that is implemented by the 'native-lib' native library,
//     * which is packaged with this application.
//     */
//    public native String stringFromJNI();
//}

public class MainActivity extends AppCompatActivity {

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
                //tpcsc = new Tpcsc(PORT);
                showLog("You are using Private API with Jar lib");
                disabelArea1();
            }
        });

        findViewById(R.id.button_mode_usb).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {

                if(getifJni()){
                    PcscServer pcscServer = new PcscServer(PORT,MainActivity.this, mHandler, DK.FTREADER_TYPE_USB);
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
                    if(ifUsb) {
                        try {
                            showLog("Open Device Failed------------>Retry");
                            readerNames = ftReader.readerOpen(null);
                            clearSpinnerPrivate();
                            addSpinnerPrivate(readerNames);
                        } catch (FTException e1) {
                            showLog("Open Device Failed------------>" + e1.getMessage());
                        }

                    }else {
                        showLog("Open Device Failed------------>" + e.getMessage());
                    }
                }
            }
        });


        findViewById(R.id.button_readerClose).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                try {
                    ftReader.readerClose();
                    clearSpinnerPrivate();
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

        findViewById(R.id.button_readerEscape).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View arg0) {
                try {
                    int index;
                    index = (ifUsb)?getSpinnerPrivate():0;
                    String sendStr = getPrivateEditTextCtl();
                    showLog("Send:"+sendStr);
                    byte[] send = Utility.hexStrToBytes(sendStr);
                    byte[] recv = ftReader.readerEscape(index,send);
                    showLog("Recv:"+ Utility.bytes2HexStr(recv));
                } catch (Exception e) {
                    e.printStackTrace();
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

    private String getPrivateEditTextCtl(){
        EditText apduEdit = (EditText)findViewById(R.id.edittext_Private_CTL);
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
        arr_adapter.add("ben_262 card as follow");
        arr_adapter.add("00a404000a01020304050607080900");
        arr_adapter.add("8010010600");
        arr_adapter.add("8020000001");

        arr_adapter.add("80300000FB0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000");
        //arr_adapter.add("80300000FA00010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849");
        arr_adapter.add("80300000010600010203040506070809101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950515253545556575859606162636465666768697071727374757677787980818283848586878889909192939495969798990001020304050607080910111213141516171819202122232425262728293031323334353637383940414243444546474849505152535455565758596061");
        arr_adapter.add("8010010600");
        arr_adapter.add("black-white type B");
        arr_adapter.add("00A404000BA000000291A00000019102");
        arr_adapter.add("00B201A420");
        arr_adapter.add("00B201AC40");
        arr_adapter.add("好的之扩展指令select app, write 128,read,write 250,read,write 256,read");
        arr_adapter.add("00A40400051122334455");
        arr_adapter.add("128bytes");
        arr_adapter.add("0001000080f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3");
        arr_adapter.add("00020000");
        arr_adapter.add("250bytes");
        arr_adapter.add("00010000FAf22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74edb81635f5c3f22b672d5c76a1653d7ed0478fdcf7542334f77a7b0c108b74dea5ee276b3f951253d52e73e34b9ef52e38ab8e5fecf8a84db2377f50529aca54da8a9d2b9e9c8e287ec117e967bd3b741dda6c8637ddad276b39f4820b83d2f4d0265563d7582ed1e94c0f408521da0025d613a006bf3b33946c465b89677c74");
        arr_adapter.add("00020000");
        arr_adapter.add("256bytes");
        arr_adapter.add("00010000000100016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
        arr_adapter.add("00020000");
        arr_adapter.add("262bytes");
        arr_adapter.add("00010000000106016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395112233445566");
        arr_adapter.add("00020000");
        arr_adapter.add("300bytes");
        arr_adapter.add("0001000000012Cff001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899001122334455667788990011223344556677889900112233445566778899");
        arr_adapter.add("00020000");
        arr_adapter.add("512bytes");
        arr_adapter.add("00010000000200016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
        arr_adapter.add("00020000");
        arr_adapter.add("1024bytes");
        arr_adapter.add("00010000000400016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
        arr_adapter.add("00020000");
        arr_adapter.add("2048bytes");
        arr_adapter.add("00010000000800016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395016e0967bfaead620f0c246db4a52a20e8777f2d4d24a78fd9929d1aa7e556501f774008537b375bbf2e66834b5138897e41dbb73ab9f171d825f8304f7788ba0a7f3d45fc005d8d702077afcb8ff72cb98893ca6e51ddb01ba84036bb135083c508530bb1b1d85bccfb228e5486a6aec305e966dc535e594cb68abb7e8725f9f0f49c38fef69c79ff92943d9f2a231c15762993f186ac19361141b3a60fabdb59b6ef8492efef60edcc63adca215771e96b9fcc9d777fbf588af57f74eafcf3f69b3824dbb54629ac6bc5cc3f27ca197dcfdfaaa31946cbb5a09028791521071d558f5168edce7d13ec54c5c5995a5d253fe3ea8ce37c4d6d5e388332495395");
        arr_adapter.add("00020000");
        arr_adapter.add("好的之com");
        arr_adapter.add("00A40400050102030405" );
        arr_adapter.add("8010007000" );
        arr_adapter.add("8010012100");
        arr_adapter.add("好的之长返回");
        arr_adapter.add("00A404000A01020304050607080900");
        arr_adapter.add("80200000EE" );
        arr_adapter.add("80200000EF" );
        arr_adapter.add("80200000F0" );
        arr_adapter.add("80200000F1" );
        arr_adapter.add("80200000FE" );
        arr_adapter.add("80200000FF" );
        arr_adapter.add("801000e3000000");
        arr_adapter.add("802000000003e3");
        arr_adapter.add("801000f100");
        arr_adapter.add("好的之超时0--0x40");
        arr_adapter.add("00A404000A01020304050607081000");
        arr_adapter.add("8010000000" );
        arr_adapter.add("8010000100" );
        arr_adapter.add("8010000200" );
        arr_adapter.add("8010000300" );
        arr_adapter.add("8010004000" );
        arr_adapter.add("Mifare 1k card");
        arr_adapter.add("FF82000106FFFFFFFFFFFF" );
        arr_adapter.add("FF860000050100016000" );
        arr_adapter.add("FFB0000210" );
        arr_adapter.add("FFD600021011223344556677889900AABBCCDDEEFF" );
        arr_adapter.add("FFD600021001000000FEFFFFFF0100000001FE01FE" );
        arr_adapter.add("压力测试卡");
        arr_adapter.add("007700000004005198ACAA3574C9815E246CBA92328EB4BE9DB925D26A78BCD25B0D052AFF618C43EB41455346C62B798B1528098A493525B0AEC28D893058B783137D23F5E4D8E95FAF9594F4720B3255D29CACA00DDD54A930F7BD878A4ECF5360601A2CE2EF6B7E5E629D84B469B20C0AE0237BC0F67310A68E0A6D6DE541535C75BAAD441AF2D0B6741901738C213724BA15234CC6AC6E7A4D1E42C366360B6F86A87FF3A1A6DC2092AE7099BDA65F8AF32AA19796254A13FD9E0E7319D50402598FAAD6CCAE2A028604DB0D44690BA3530BFC8BAD062CD96635D9654647C57BB81537D4E23242C516C449B76993C3D7A1603C0F55789C344F89AC8135B3D64469E22DD72D5CADD20B96C37F744C108EA7D06A0AD4A3238C81428EAF2E42C0C3349F94C6F352F2902C21504DACBB78302B048C6673AE4849C50988D7781C0A62E3F474887D3C9966430EF8095A098525F6A4AD0A7AC194D3E186A1E15C683C883C88D60713432ABE1604C39BC65DBFD6D057D2DE31068E939D60E1B5224FDF9C0904C12AFD8F2EFF6FACBAEB38E0ADA980C505CADFA2BEEFC33F503B12F87A08100F3ED982472D9014AEE4E2F8BAD707D0974DB6CEC0AC5019CDF75C738B95331A5254FCEB93ADDBCDB14A664D12C5598675B38A4486E11F69AFDDFE8F32B885EE750B7C809C3847645DF260811000056B063D2E8A1CE4C279900A0AAC136C66561F6B3F898A553C9F5CE6B9DADE0F7547F3F58AE8AB3DA3111687691356383E18F87D2E4E858D2248532E57A1A17A0FE2E3E387A55B7528FBE95B010C24A575FDA9483117B4666225EDD0241D84CA3D037F0E0B0B5313BBFEB28EBCDEA53A73CDDAD4312B3F6A62FFD0D60798AC8666746F7EFF60BC9FC3E1192981D3007FA150322A14D34F218B9DA447E7584436F1FB5A3B4CEDBDA1A86DC53337315EFC654D5A51C4570C1245C9122CAEA672624861E94ED8FA7FA2D16A5FB4C841E63A288EFA5127FF9DC5F949C18C43CA5E93D26DC3BE8DCF2A2AA8A08EB51B4BC1C053D9B93327122AC20DE65B6F8E0C3250F7E9909352B3E5BF94D6FB3C189716164CF73FFEABDADD92EB6885DE77B413221F9BFAD50EF0D8EBFDD64E54A76C0EC57DB035BA9A9DDCBCF997E9DFE6092B90B24DA78DABCC2C354B662E02B014D1544CCB4370DEA44FC8A13B2F7DC354A22218C53FC310900925E74F43501BD5864B231210275E375F3E4A1BFFBDF6DDA060BACC6B7D2583964437583645D0F85533694B45E7029E33A75B00FFA967EC4CD3FE29D3C5D2EFFC19A44BAFE9B8C46792863F89B8B220F58B3EB2DA48FFC9CE024DA61EA2FF1A622D97EF5545B983E4F3E2B685A35606CA705AF936A2A4BC4F751009F41D944DF106760BD160BC7BF4DBE578E1AFD699DCE0179DBCC03F0CF7B5AD1BFF3C79D0D12EAA68CA43AAF6BDD4F74C44E51A1E");
        arr_adapter.add("00a4040006112233445566");
        arr_adapter.add("00400000000400724183DDDD6234D037FDA7E7DC8EBA9C326EB036314AD4E322D45F06A6B89CD2FBD24A187B9E425D65F05A30E0E588BB3D194B977D1A46E5131D2E9AEBF0E71AAA30EA0938BCEA5D7C69B7B866F862F63345A201ECC076ED30210C413458E29208C32B571CA474F802D2872875AF90759B597E1D8725AC240249C1A38BD8D5639CF4D5AA2F3F28558192922716F25961FDBFA793552F30B110FB1469F75807B4EE29AFAC7A734D9D8011A05E50A907E2E1DEE50A5EC749BDE2A0CF3B81C0C1AE87CB820304292DF788B779752BBCE01FD01E002BABD6417001A1B8C02FF84B79EE431657D54A0E8C20ECE413AF132D4152E7BF9D43425EF1F46498A10BE9ED3CABF83351F6BC3984D018ABE0E596356FEDA1EB082FF5E969435336861D79EF204751A1986E69F60620A39486D42E42D22BB44C1675D529FF77D55C156C91984C49B827D545378D3A99F568AA84C19A929389AA6D1FCC68DC1751D0F9001A31E839948FB084104549C276EEF7FE3886D6AD86CDB534C1EC27AB315BD8E1FA021EA04C9FD032DB675B238FF012497C4EC602147D97BD9BFF09BCDCC55B181B5314054A20DE57803B9745A634A66D743A8B199C81BAC144E7AAD1BAD629AB636CF2F0F5D981FCE60926AF2584597307924D7A84A2C848A3EC31723356EBA5BC94E1E9B5946227F71930E972A6D3621F9D33AE35A8665BA058C727AF0C480B0D150979F21729E39AB2DC7CF762BD42A3A4663C185B3E002371937996C1E9E73E359127142B7D35B71E52EF1A82BF1C7AEF0EAC9482F8411481BEEF503D7540363DA17C8398062737A3BBCA45CC80F78EC6518710E73C265BCE6F124548951FDF7563FFA8266DC0008A3F96DF0AA9DBC6715A54F650B0B6E1A1CF68DEAAF18B2024FD38E99D5A08FB1B05DA5002E1D00A374F9BAD86FFF98C41067B812A308CE19397AFAFC47408109D361EFF7DD1DF426259E59D51CFF745F83BD39792FA2A0A0B5AED636464C7285AF9EB5642210F56389FB82E78C9B9F50C96F689A8F96E84D26D796B45D14D299877C7BC1B78692F024A9FC8C5944682C6406EBD35D25F3530F9DB312F64A3FDA0D73D99CE7EF3B307811FD3FED8A6D66E61C39D003006066F269C1BEAC5D08ABA42D25624DCB7CB916DC2B7EC3FE2D74C207B90D3B969DFD61B43933D9BDCBA2DE01059E53ABD60E6350FDC576F016FA7A620FD741592A9AC015800F28FD07343D87E0BD93F0B584F038EAB07100B85C91B394EACED894A3AFF63CACF48B39F4253A4D4C794AB9D14FCC88AC3CB0900F8A64FEA43E954ACC83EED589D6F8D2573780B1D79E1A5157D4A44E2544802CA7D6FE93901B0FDB59DE67D1423AB67ED1E703A4CB5CDFFAAD2158A1C832EFECAA09F8FA3AEEB8C4F031E9C652BA548DF8B62B9CB4400C3435A84239E162505E8A85ECA9011410761400E");

        return arr_adapter;
    }

}
