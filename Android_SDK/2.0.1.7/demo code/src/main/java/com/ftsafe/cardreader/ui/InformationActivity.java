package com.ftsafe.cardreader.ui;

import static com.ftsafe.cardreader.ui.CardReaderManagertActivity.connectedReaderIndex;
import static com.ftsafe.cardreader.ui.CardReaderManagertActivity.showMessage;
import static com.ftsafe.cardreader.ui.ConnectActivity.TAG;
import static com.ftsafe.cardreader.ui.ConnectActivity.connectedDeviceList;
import static com.ftsafe.cardreader.ui.ConnectActivity.deviceType;
import static com.ftsafe.cardreader.ui.ConnectActivity.foundUSBDevices;
import static com.ftsafe.cardreader.ui.ConnectActivity.isAutoConnect;

import android.annotation.SuppressLint;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.TextView;
import android.widget.ToggleButton;

import androidx.annotation.RequiresApi;

import com.ftsafe.DK;
import com.ftsafe.Utility;
import com.ftsafe.cardreader.R;
import com.ftsafe.cardreader.utils.Convection;
import com.ftsafe.readerScheme.FTException;
import com.ftsafe.readerScheme.FTReader;

public class InformationActivity extends BaseActivity implements View.OnClickListener{
    private Context mContext;
    private FTReader mFtReader;
    private TextView text_SdkVersion, text_AppVersion,text_FirmwareVersion,text_Manu,text_Serial,text_Model,text_ReaderName,text_BleID,text_BleVersion,text_uuid;

    private ToggleButton ToggleButton1,ToggleButton2;//按键监听

    public static Boolean isAutoTurnOff = false;

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_information);
        mContext = this;
        initView();
        initData();
    }

    @SuppressLint("HandlerLeak")
    Handler mHandler = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            super.handleMessage(msg);
            switch (msg.what){
                //Bluetooth device scanned.
                case DK.BT4_NEW:
                case DK.BT3_NEW:
                    BluetoothDevice device3 = (BluetoothDevice) msg.obj;
                    if(device3 != null && device3.getName() != null){
                        showMessage(device3.getName()+" is connected！");
                    }
                    break;
                case DK.USB_LOG:
                    //Otg device found.
                    break;
                case DK.BT3_DISCONNECTED:
                    showMessage("Bluetooth device has been disconnected.");
                    ConnectActivity.connectHandler = null;
                    ConnectActivity.isConnected = false;
                    Intent intent = new Intent(InformationActivity.this, ConnectActivity.class);
                    startActivity(intent);
                    finish();
                    break;
                case DK.BT4_ACL_DISCONNECTED:
                    showMessage("BLE device has been disconnected.");
                    ConnectActivity.connectHandler = null;
                    ConnectActivity.isConnected = false;
                    intent = new Intent(InformationActivity.this, ConnectActivity.class);
                    startActivity(intent);
                    finish();
                    break;
                case DK.USB_IN:
                    showMessage("Information Activity: USB device has been inserted.");
                    break;
                case DK.USB_OUT:
                    showMessage("USB device out");
                    ConnectActivity.connectHandler = null;
                    if (connectedDeviceList.size() == 0){
                        ConnectActivity.connectHandler = null;
                        ConnectActivity.isConnected = false;
                        intent = new Intent(InformationActivity.this, ConnectActivity.class);
                        startActivity(intent);
                        finish();
                    }
                    break;
                default:
                    if((msg.what & DK.CARD_IN_MASK) == DK.CARD_IN_MASK){
                        //Card in.
                        showMessage("Card slot " + (msg.what%DK.CARD_IN_MASK) + " in.");
                        return;
                    }else if((msg.what & DK.CARD_OUT_MASK) == DK.CARD_OUT_MASK){
                        //Card out.
                        showMessage("Card slot " + (msg.what%DK.CARD_OUT_MASK) + " out.");
                        return;
                    }
                    break;
            }
        }
    };

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    public void initData(){
        ConnectActivity.connectHandler = mHandler;
        mFtReader = ConnectActivity.mFtReader;
        text_SdkVersion.setText(mFtReader.getSDKVersion());
        text_AppVersion.setText(mFtReader.getAppVersion());
        text_FirmwareVersion.setText(getreaderfirmversion());
        text_Manu.setText(getManufacturer());
        if(deviceType != DK.FTREADER_TYPE_USB || getDeviceType().equals("READER_BR301BLE") || getDeviceType().equals("READER_BR500") || getDeviceType().equals("READER_BR301")){
            text_Serial.setText(readerGetDeviceHID());
        }else if (getDeviceType().equals("READER_IR301_LT")){
            text_Serial.setText(readerGetSerialNum());
        }else{
            String sn = foundUSBDevices.get(connectedReaderIndex).getSerialNumber();
            if (sn == null){
                text_Serial.setText("null");
            }else{
                text_Serial.setText(sn);
            }
        }

        if (deviceType == DK.FTREADER_TYPE_USB || deviceType == DK.FTREADER_TYPE_BT3){
            text_BleID.setVisibility(View.GONE);
            findViewById(R.id.text_bleID_name).setVisibility(View.GONE);
            findViewById(R.id.text_bleID_view).setVisibility(View.GONE);
            text_BleVersion.setVisibility(View.GONE);
            findViewById(R.id.text_ble_version_name).setVisibility(View.GONE);
            findViewById(R.id.text_ble_version_view).setVisibility(View.GONE);
        }else {
            text_BleID.setText(connectedDeviceList.get(0));
            text_BleVersion.setText(getBleversion());
        }
        text_ReaderName.setText(getReaderName());
        if (readerGetAccessoryModeNumber()==null){
            text_Model.setVisibility(View.GONE);
            findViewById(R.id.text_model_number_name).setVisibility(View.GONE);
            findViewById(R.id.text_model_number_view).setVisibility(View.GONE);
        }else{
            text_Model.setText(readerGetAccessoryModeNumber());
        }
        text_uuid.setText(getUid());
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    private void initView() {
        isAutoConnect = Convection.getIsAutoConnect(mContext);
        isAutoTurnOff = Convection.getIsAutoTurnOff(mContext);
        text_SdkVersion = findViewById(R.id.text_sdk_version);
        text_SdkVersion.setOnClickListener(this);
        text_AppVersion = findViewById(R.id.text_app_version);
        text_AppVersion.setOnClickListener(this);
        text_FirmwareVersion = findViewById(R.id.text_firmware_version);
        text_FirmwareVersion.setOnClickListener(this);
        text_Manu = findViewById(R.id.text_manu);
        text_Manu.setOnClickListener(this);
        text_Serial = findViewById(R.id.text_serial_number);
        text_Serial.setOnClickListener(this);
        text_Model = findViewById(R.id.text_model_number);
        text_Model.setOnClickListener(this);
        text_ReaderName = findViewById(R.id.text_reader_name);
        text_ReaderName.setOnClickListener(this);
        text_BleID = findViewById(R.id.text_bleID);
        text_BleID.setOnClickListener(this);
        text_BleVersion = findViewById(R.id.text_ble_version);
        text_BleVersion.setOnClickListener(this);
        text_uuid = findViewById(R.id.text_uuid);

        ToggleButton1 = findViewById(R.id.checkbox1);
        ToggleButton1.setOnClickListener(this);
        if (isAutoConnect) {
            //如果之前已经设置自动连接则需要此句改变按钮UI
            ToggleButton1.setButtonDrawable(getDrawable(R.drawable.open));
            ToggleButton1.setChecked(true);
        }
        ToggleButton2 = findViewById(R.id.checkbox2);
        ToggleButton2.setOnClickListener(this);
        if (isAutoTurnOff) {
            //如果之前已经设置自动连接则需要此句改变按钮UI
            ToggleButton2.setButtonDrawable(getDrawable(R.drawable.open));
            ToggleButton2.setChecked(true);
        }
        ToggleButton1.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    ToggleButton1.setButtonDrawable(getDrawable(R.drawable.open));
                    isAutoConnect = true;
                    Convection.setIsAutoConnect(mContext,true);
                }else{
                    ToggleButton1.setButtonDrawable(getDrawable(R.drawable.close));
                    isAutoConnect = false;
                    Convection.setIsAutoConnect(mContext,false);
                }
            }
        });
        ToggleButton2 = findViewById(R.id.checkbox2);
        ToggleButton2.setOnClickListener(this);
        ToggleButton2.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                String result;
                if (isChecked) {
                    ToggleButton2.setButtonDrawable(getDrawable(R.drawable.open));
                    isAutoTurnOff = true;
                    Convection.setIsAutoTurnOff(mContext,true);
                    result = autoTurnOff(false);
                }else{
                    ToggleButton2.setButtonDrawable(getDrawable(R.drawable.close));
                    isAutoTurnOff = false;
                    Convection.setIsAutoTurnOff(mContext,false);
                    result = autoTurnOff(true);
                }
            }
        });
        if (deviceType == DK.FTREADER_TYPE_USB){
            ToggleButton2.setEnabled(false);
        }

        findViewById(R.id.view_back).setOnClickListener(this);
        findViewById(R.id.btn_back).setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        int id = v.getId();
        if  (id == R.id.btn_back){
//                Intent intent = new Intent(InformationActivity.this, CardReaderManagertActivity.class);
//                startActivity(intent);
                finish();
        } else if (id == R.id.view_back){
//                Intent intent = new Intent(InformationActivity.this, CardReaderManagertActivity.class);
//                startActivity(intent);
            finish();
        }
    }

    String autoTurnOff(final boolean isOpen){
        try {
            byte[] result = mFtReader.FT_AutoTurnOffReader(connectedDeviceList.get(connectedReaderIndex),isOpen);
            return (isOpen?"open":"close") + " auto turn off : " + Utility.bytes2HexStr(result);
        } catch (FTException e) {
            e.printStackTrace();
            return (isOpen?"open":"close") + " auto turn off \n" + e.getMessage();
        }
    }

    String getManufacturer(){
        try {
            byte[] result = mFtReader.readerGetManufacturer(connectedDeviceList.get(connectedReaderIndex));
            return Convection.convertHexToString(Convection.Bytes2HexString(result));
        } catch (FTException e) {
            e.printStackTrace();
            return e.toString();
        }
    }

    String getBleversion(){
        String bleVersion = null;
        try {
            bleVersion = mFtReader.getBleFirmwareVersion();
            bleVersion = bleVersion.substring(1,2)+"."+bleVersion.substring(3,4)+"."+bleVersion.substring(bleVersion.length()-2);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bleVersion;
    }

    String getreaderfirmversion(){
        String version = null;
        try {
            version = mFtReader.readerGetFirmwareVersion(connectedDeviceList.get(connectedReaderIndex));
        } catch (FTException e) {
            e.printStackTrace();
        }
        return version;
    }

    String getReaderName(){
        try {
            byte[] readerName = mFtReader.readerGetReaderName(connectedDeviceList.get(connectedReaderIndex));
            String rederNameStr = Convection.convertHexToString(Convection.Bytes2HexString(readerName));
            return rederNameStr;
        } catch (FTException e) {
            e.printStackTrace();
        }
        return null;
    }

    String getDeviceType(){
        String result = "";
        try {
            int type = mFtReader.readerGetType(connectedDeviceList.get(connectedReaderIndex));
            Log.e(TAG,"card reader type："+type);
            switch (type){
                case DK.READER_R301E:
                    result = "READER_R301";
                    break;
                case DK.READER_R502_C9_U10:
                    result = "READER_R502_E7";
                    break;
                case DK.READER_BR301FC4:
                    result = "READER_BR301BLE";
                    break;
                case DK.READER_BR500:
                    result = "READER_BR500";
                    break;
                case DK.READER_R502_CL:
                    result = "READER_R502_CL";
                    break;
                case DK.READER_R502_DUAL:
                    result = "READER_R502_DUAL";
                    break;
                case DK.READER_BR301:
                    result = "READER_BR301";
                    break;
                case DK.READER_IR301_LT:
                    result = "READER_IR301_LT";
                    break;
                case DK.READER_IR301:
                    result = "READER_IR301";
                    break;
                case DK.READER_VR504:
                    result = "READER_VR504";
                    break;
                case DK.READER_BCR610DTP:
                    result = "READER_BCR610DTP";
                    break;
                case DK.READER_UNKNOWN:
                default:
                    result = "READER_UNKNOWN";
            }
        } catch (FTException e) {
            e.printStackTrace();
        }
        return result;
    }

    String readerGetDeviceHID() {
        byte[] outData = new byte[255];
        int[] length = new int[1];
        try {
            mFtReader.readerGetDeviceHID(0,length,outData);
        } catch (FTException e) {
            e.printStackTrace();
        }
        return Convection.Bytes2HexString(outData).substring(0,length[0]*2);
    }

    String readerGetSerialNum() {
        byte[] outData = new byte[255];
        int[] length = new int[1];
        try {
            outData = mFtReader.readerGetSerialNumber(connectedDeviceList.get(connectedReaderIndex));
        } catch (FTException e) {
            e.printStackTrace();
        }
        return Convection.hexToString(Convection.Bytes2HexString(outData).substring(0,length[0]*2));
    }

    String readerGetAccessoryModeNumber() {
        byte[] outData = new byte[255];
        int[] length = new int[1];
        try {
            mFtReader.readerGetAccessoryModeNumber(0,length,outData);
        } catch (FTException e) {
            e.printStackTrace();
        }
        String StrOutData16 = Convection.Bytes2HexString(outData);
        if (outData[0]==0){
            return null;
        }else {
            return Convection.convertHexToString(StrOutData16).substring(0,length[0]*2);
        }
    }

    String getUid(){
        String uuid;
        try {
            byte[] uid = mFtReader.readerGetUID(connectedDeviceList.get(connectedReaderIndex));
            uuid = "<" + Utility.bytes2HexStr(uid) + ">";
        } catch (FTException e) {
            e.printStackTrace();
            uuid = null;
        }
        return uuid;
    }

    //禁用物理返回键
    @Override
    public void onBackPressed() {
    }

}
